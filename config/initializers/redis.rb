# frozen_string_literal: true

# config/initializers/redis.rb

redis_host = (Rails.application.credentials.redis && Rails.application.credentials.redis['host']) || 'localhost'
redis_port = (Rails.application.credentials.redis && Rails.application.credentials.redis['port']) || 6379

# The constant below will represent ONE connection, present globally in models, controllers, views etc for the instance. No need to do Redis.new everytime
REDIS = Redis.new(host: redis_host, port: redis_port.to_i)

# https://stackoverflow.com/questions/62628988/rails-6-actioncable-redis-production-configuration
# https://devcenter.heroku.com/articles/heroku-redis#connecting-in-ruby
