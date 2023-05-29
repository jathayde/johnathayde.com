require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  fog_directory: ENV['FOG_DIRECTORY'],
  fog_region: ENV['FOG_REGION']
)

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://johnathayde.com'
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog (pass in configuration values as shown above if needed)
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'weekly', :priority => 0.9
  add '/contact', :changefreq => 'monthly'
  add '/resume', :changefreq => 'monthly'
  add '/music', :changefreq => 'monthly'
  add '/speaking', :changefreq => 'monthly'

  Appearance.all.each do |appearance|
    add "/speaking/appearances/#{appearance.id}", :changefreq => 'monthly'

    appearance.recordings.each do |recording|
      add "/speaking/appearances/#{appearance.id}/recordings/#{recording.id}", :changefreq => 'monthly'
    end
  end

  Talk.all.each do |talk|
    add "/speaking/talks/#{talk.id}", :changefreq => 'monthly'
  end

  add '/work', :changefreq => 'monthly'
  add '/work/livingsocial-csr', :changefreq => 'monthly'
  add '/work/navanti-pulse', :changefreq => 'monthly'
  add '/work/procore', :changefreq => 'monthly'
  add '/work/powerfleet-chassis', :changefreq => 'monthly'
end

SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks