require 'aws-sdk-s3'
require 'open3'
require 'date'

namespace :db do
  desc "Pull the latest production database backup from S3, restore it locally, and run migrations"
  task :restore_from_s3 => :environment do
    # AWS S3 configuration
    bucket_name = "dokku-johnathayde-backup"
    db_name = "johnathayde_development"
    region = ENV['AWS_REGION'] || 'us-east-1'

    # Check for AWS credentials
    access_key_id = ENV['AWS_ACCESS_KEY_ID']
    secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    
    if !access_key_id || !secret_access_key
      puts "AWS credentials not found in environment variables."
      puts "Please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY with appropriate permissions."
      puts "You can also specify AWS_REGION if needed (defaults to us-east-1)."
      
      print "\nWould you like to enter AWS credentials now? (y/n): "
      response = STDIN.gets.strip.downcase
      
      if response == 'y'
        print "Enter AWS Access Key ID: "
        access_key_id = STDIN.gets.strip
        
        print "Enter AWS Secret Access Key: "
        secret_access_key = STDIN.gets.strip
        
        print "Enter AWS Region (leave blank for us-east-1): "
        input_region = STDIN.gets.strip
        region = input_region.empty? ? region : input_region
      else
        puts "Exiting. Please configure AWS credentials and try again."
        exit 1
      end
    end
    
    # Initialize S3 client with credentials
    s3 = Aws::S3::Client.new(
      region: region,
      access_key_id: access_key_id,
      secret_access_key: secret_access_key
    )

    puts "Using AWS credentials for access key: #{access_key_id}"
    
    # List backup files and find the most recent one
    puts "Fetching list of database backups from S3..."
    begin
      backup_files = []
      
      puts "Listing objects in bucket: #{bucket_name}..."
      s3.list_objects_v2(bucket: bucket_name).each do |response|
        puts "Found #{response.contents.length} objects in the bucket"
        response.contents.each do |object|
          puts "Checking object: #{object.key}"
          
          # Check for this app's filename format:
          # postgres-johnathayde_production-YYYY-MM-DD-HH-MM-SS.tgz
          if object.key.match?(/^postgres-johnathayde_production-\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}/) && 
             object.key.end_with?('.tgz', '.tar.gz', '.dump', '.sql')
            backup_files << object.key
            puts "  => Added to backup files list: #{object.key}"
          end
        end
      end
      
      puts "Found #{backup_files.length} potential database backup files"
      
      if backup_files.empty?
        puts "No database backups found in S3 bucket '#{bucket_name}'!"
        exit 1
      end
      
      # Sort files by date (newest first)
      backup_files.sort! do |a, b|
        # Extract date parts from the filename format:
        # postgres-johnathayde_production-YYYY-MM-DD-HH-MM-SS.tgz
        date_parts_a = a.match(/postgres-johnathayde_production-(\d{4})-(\d{2})-(\d{2})-(\d{2})-(\d{2})-(\d{2})/)
        date_parts_b = b.match(/postgres-johnathayde_production-(\d{4})-(\d{2})-(\d{2})-(\d{2})-(\d{2})-(\d{2})/)
        
        if date_parts_a.nil? || date_parts_b.nil?
          puts "Warning: Filename format doesn't match expected pattern:"
          puts "  File A: #{a}"
          puts "  File B: #{b}"
          next 0 # Skip comparison if format doesn't match
        end
        
        # Construct datetime objects manually
        begin
          # Extract individual components
          year_a, month_a, day_a, hour_a, min_a, sec_a = date_parts_a[1..6].map(&:to_i)
          year_b, month_b, day_b, hour_b, min_b, sec_b = date_parts_b[1..6].map(&:to_i)
          
          # Create Time objects
          time_a = Time.new(year_a, month_a, day_a, hour_a, min_a, sec_a)
          time_b = Time.new(year_b, month_b, day_b, hour_b, min_b, sec_b)
          
          # Compare times (newest first)
          time_b <=> time_a
        rescue => e
          puts "Error parsing date from filenames: #{e.message}"
          # Log the problematic filenames
          puts "File A: #{a}, File B: #{b}"
          0 # Skip comparison on error
        end
      end
      
      latest_backup = backup_files.first
      
      # Print all backup files found
      puts "\nFound backup files:"
      backup_files.each_with_index do |file, index|
        puts "#{index + 1}. #{file}"
      end
      
      # Extract the date part for user confirmation
      date_parts = latest_backup.match(/postgres-johnathayde_production-(\d{4})-(\d{2})-(\d{2})/)
      
      if date_parts.nil?
        puts "Warning: Latest backup filename doesn't match expected pattern: #{latest_backup}"
        puts "Will continue with this file, but please verify it's the correct one."
        date_part = "unknown date (#{latest_backup})"
      else
        year, month, day = date_parts[1..3]
        date_part = "#{year}-#{month}-#{day}"
      end
      
      # Ask for confirmation or manual selection
      puts "\nLatest database backup is from: #{date_part}"
      puts "Options:"
      puts "  y - Use the latest backup (#{latest_backup})"
      puts "  n - Cancel the operation"
      puts "  s - Manually select a backup from the list"
      print "What would you like to do? (y/n/s): "
      
      response = STDIN.gets.strip.downcase
      
      if response == 's'
        # Let user select a backup manually
        valid_selection = false
        selection = nil
        
        until valid_selection
          puts "\nAvailable backups:"
          backup_files.each_with_index do |file, index|
            puts "#{index + 1}. #{file}"
          end
          
          print "\nEnter the number of the backup to use (1-#{backup_files.length}): "
          selection = STDIN.gets.strip.to_i
          
          if selection >= 1 && selection <= backup_files.length
            valid_selection = true
            latest_backup = backup_files[selection - 1]
            puts "Selected backup: #{latest_backup}"
          else
            puts "Invalid selection. Please try again."
          end
        end
      elsif response != 'y'
        puts "Database restoration cancelled."
        exit 0
      end
      
      # Create a temporary directory
      temp_dir = File.join(Rails.root, 'tmp', 'database_restore')
      FileUtils.mkdir_p(temp_dir)
      
      local_backup_path = File.join(temp_dir, latest_backup)
      
      # Download the backup file
      puts "\nDownloading latest backup file: #{latest_backup}..."
      s3.get_object(
        bucket: bucket_name,
        key: latest_backup,
        response_target: local_backup_path
      )
      puts "Download completed."
      
      # Extract the compressed backup file if it's compressed
      puts "Extracting database dump..."
      if local_backup_path.end_with?('.tgz', '.tar.gz')
        extraction_cmd = "tar -xzf #{local_backup_path} -C #{temp_dir}"
        system(extraction_cmd)
        
        # List all files that were extracted for debugging
        puts "Extracted files:"
        system("find #{temp_dir} -type f | sort")
        
        # Check for common extraction patterns:
        # 1. Standard .dump or .sql file in the root of the temp directory
        # 2. 'backup/export' file in a subdirectory
        # 3. Any .dump or .sql file in any subdirectory
        
        dump_file = Dir.glob(File.join(temp_dir, '*.dump')).first || 
                    Dir.glob(File.join(temp_dir, '*.sql')).first ||
                    File.join(temp_dir, 'backup', 'export')
        
        # If we found the 'backup/export' file
        if dump_file == File.join(temp_dir, 'backup', 'export') && File.exist?(dump_file)
          puts "Found database export file at: #{dump_file}"
          
          # Determine if it's a PostgreSQL dump file by checking the first few bytes
          file_type = `file -b #{dump_file}`.strip
          puts "File type detected: #{file_type}"
          
          if file_type.include?('PostgreSQL') || file_type.include?('SQL')
            # It's a valid dump file, but has no extension
            # Copy it to a new file with a .dump extension for clarity
            dump_file_with_ext = "#{dump_file}.dump"
            FileUtils.cp(dump_file, dump_file_with_ext)
            dump_file = dump_file_with_ext
            puts "Copied to file with .dump extension: #{dump_file}"
          end
        elsif !File.exist?(dump_file.to_s)
          # Try to find any file that might be a database dump
          puts "Standard dump file not found. Searching for any potential dump file..."
          potential_dumps = Dir.glob(File.join(temp_dir, '**/*')).select do |f| 
            File.file?(f) && (`file -b #{f}`.include?('PostgreSQL') || `file -b #{f}`.include?('SQL')) 
          end
          
          if potential_dumps.any?
            dump_file = potential_dumps.first
            puts "Found potential dump file: #{dump_file}"
          else
            puts "Error: Could not find a database dump file after extraction!"
            puts "Contents of extracted archive:"
            system("find #{temp_dir} -type f -exec file {} \\;")
            exit 1
          end
        end
      else
        # If it's not compressed, just use it directly
        dump_file = local_backup_path
      end
      
      # Verify the dump file exists
      unless File.exist?(dump_file.to_s)
        puts "Error: The identified dump file does not exist: #{dump_file}"
        exit 1
      end
      
      puts "Using database dump file: #{dump_file}"
      
      # Drop existing database
      puts "\nDropping existing database..."
      system("PGPASSWORD=$PGPASSWORD dropdb --if-exists #{db_name}")
      
      # Create a new database
      puts "Creating new database..."
      system("PGPASSWORD=$PGPASSWORD createdb #{db_name}")
      
      # Enable PostGIS extension
      puts "Enabling PostGIS extension..."
      system("psql -d #{db_name} -c 'CREATE EXTENSION IF NOT EXISTS postgis;'")
      
      # Restore the database from the dump file
      puts "Restoring database from backup..."
      
      # Determine the type of dump file for proper restoration
      file_type = `file -b #{dump_file}`.strip
      puts "Dump file type: #{file_type}"
      
      # Choose the appropriate restore command based on file type
      if file_type.include?('PostgreSQL custom format') || dump_file.end_with?('.dump')
        puts "Using pg_restore for custom format dump..."
        result = system("pg_restore --verbose --no-owner --no-acl -d #{db_name} #{dump_file}")
      elsif file_type.include?('gzip compressed') || dump_file.end_with?('.gz')
        puts "Using gunzip and psql for compressed SQL dump..."
        result = system("gunzip -c #{dump_file} | psql -d #{db_name}")
      else
        puts "Using psql for plain SQL dump..."
        result = system("psql -d #{db_name} -f #{dump_file}")
      end
      
      # Check if the restore was successful
      if result
        puts "Database restore completed successfully."
      else
        puts "WARNING: Database restore may have encountered issues. Exit code: #{$?.exitstatus}"

        # For custom format dumps, try with --clean --if-exists options if the first attempt failed
        if file_type.include?('PostgreSQL custom format') && !result
          puts "Trying alternative restore command..."
          result = system("pg_restore --verbose --clean --if-exists --no-owner --no-acl -d #{db_name} #{dump_file}")
          puts result ? "Second attempt successful!" : "Second attempt also failed."
        end
      end

      # Strip PostGIS from the restored database.
      # Production has PostGIS installed (inherited from the Dokku image), but
      # this app has no geospatial features. Leaving PostGIS in place causes
      # schema:dump to emit enable_extension "postgis" and a spatial_ref_sys
      # table dump, which then breaks schema:load on a fresh test database
      # (the purge step can't drop spatial_ref_sys while the extension exists).
      # Drop the extension here so the restored dev DB matches the app's
      # actual extension requirements.
      puts "\nStripping PostGIS extension (no geospatial usage in this app)..."
      system("psql -d #{db_name} -c 'DROP EXTENSION IF EXISTS postgis CASCADE;'")

      # Run migrations to ensure schema is up to date
      puts "\nRunning migrations..."
      Rake::Task["db:migrate"].invoke
      
      # Clean up temporary files
      puts "Cleaning up temporary files..."
      FileUtils.rm_rf(temp_dir)
      
      puts "\nDatabase restoration completed successfully!"

    rescue Aws::S3::Errors::ServiceError => e
      puts "Error accessing S3: #{e.message}"
      exit 1
    rescue => e
      puts "Error during database restoration: #{e.message}"
      exit 1
    end
  end
end