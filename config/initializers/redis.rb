# frozen_string_literal: true

# config/initializers/redis.rb
#
# Establishes a single global Redis connection (REDIS) for use across the app.
# Configuration is read from environment variables to stay consistent with how
# the rest of the app is wired (AWS creds, SendGrid key, etc. all live in env).
#
# Supports either a full REDIS_URL (e.g. Dokku/Heroku-style redis:// URL) or
# discrete REDIS_HOST / REDIS_PORT variables. Falls back to localhost:6379 for
# development.

REDIS = if ENV["REDIS_URL"].present?
  Redis.new(url: ENV["REDIS_URL"])
else
  Redis.new(
    host: ENV.fetch("REDIS_HOST", "localhost"),
    port: ENV.fetch("REDIS_PORT", 6379).to_i
  )
end
