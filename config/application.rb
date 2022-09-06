# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JohnathaydeCom
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.active_support.cache_format_version = 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Eastern Time (US & Canada)"

    # Rails 5 now supports per-form CSRF tokens to mitigate against code-injection attacks
    # with forms created by JavaScript. With this option turned on, forms in your application
    # will each have their own CSRF token that is specified to the action and method for that form.
    # config.action_controller.per_form_csrf_tokens = true

    # You can now configure your application to check if the HTTP Origin header should be checked
    # against the site's origin as an additional CSRF defense. Set the following in your config to true
    # config.action_controller.forgery_protection_origin_check = true

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # config.active_job.queue_adapter = :sidekiq

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
      # :user_name => 'meticulous',
      # :password => 'y??Bf7xGtfmkaUTdFZPA8kzEFvN3auJw',
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
