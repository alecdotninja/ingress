require 'sidekiq'
require 'sidekiq/cron'

sidekiq_redis_config = Rails.application.config_for(:redis)&.deep_symbolize_keys
sidekiq_cron_config = Rails.application.config_for(:schedule)&.deep_symbolize_keys

Sidekiq.average_scheduled_poll_interval = 10
Sidekiq.options[:poll_interval] = 10

configure_after_fork = proc do |config|
  config.redis = sidekiq_redis_config
  Sidekiq::Cron::Job.load_from_hash(sidekiq_cron_config)
end

Sidekiq.configure_client(&configure_after_fork)
Sidekiq.configure_server(&configure_after_fork)
