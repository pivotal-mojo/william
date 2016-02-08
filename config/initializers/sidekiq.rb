if ENV['VCAP_SERVICES']
  full_config = JSON.parse(ENV['VCAP_SERVICES'])
  redis_config = full_config.values.flatten.detect do |service_config|
    service_config['name'] == 'redis'
  end
  credentials = redis_config['credentials']
  redis_url = "redis://:#{credentials['password']}@#{credentials['hostname']}:#{credentials['port']}/0"

  Sidekiq.configure_server do |config|
    config.redis = { url: redis_url }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: redis_url }
  end
end