if ENV['VCAP_SERVICES']
  full_config = JSON.parse(ENV['VCAP_SERVICES'])
  redis_config = full_config.values.flatten.detect do |service_config|
    service_config['name'] == 'redis'
  end
  credentials = redis_config['credentials']
  redis_url = "redis://:#{credentials['password']}@#{credentials['host']}:#{credentials['port']}/0"
  Sidekiq.redis = { url: redis_url, namespace: 'sidekiq' }
end