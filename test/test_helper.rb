ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'

require 'pry'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/cli'
require 'sidekiq/processor'
require 'sidekiq/manager'
require 'sidekiq/util'
require 'sidekiq/redis_connection'
require 'redis-namespace'
require 'attentive_sidekiq'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/stub_any_instance'

REDIS_URL = ENV["REDIS_URL"] || "redis://localhost:15"
REDIS_NAMESPACE = ENV["REDIS_NAMESPACE"] || 'testy'
REDIS = Sidekiq::RedisConnection.create(:url => REDIS_URL, :namespace => REDIS_NAMESPACE)

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add AttentiveSidekiq::Middleware::Server::Attentionist
  end
end

Sidekiq.logger = nil
