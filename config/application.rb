require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JohnathaydeCom
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.active_support.cache_format_version = 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.

    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.time_zone = "Eastern Time (US & Canada)"

    # config.eager_load_paths << Rails.root.join("extras")

    # Enable Gzip compression
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater

    config.generators do |g|
      # Settings for Rspec
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    # Setup controller layouts
    # config.to_prepare do
    #   Devise::SessionsController.layout "sessions"
    #   Devise::RegistrationsController.layout proc { |_controller| user_signed_in? ? "application" : "sessions" }
    #   Devise::ConfirmationsController.layout "sessions"
    #   Devise::UnlocksController.layout "sessions"
    #   Devise::PasswordsController.layout "sessions"
    # end

    # Specify cookies SameSite protection level: either :none, :lax, or :strict.
    #
    # This change is not backwards compatible with earlier Rails versions.
    # It's best enabled when your entire app is migrated and stable on 6.1.
    # config.action_dispatch.cookies_same_site_protection = :lax

    # Email sent via SendGrid
    ActionMailer::Base.smtp_settings = {
      user_name: "apikey",
      password: ENV["SENDGRID_API_KEY"],
      domain: "johnathayde.com",
      address: "smtp.sendgrid.net",
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true
    }
  end
end
