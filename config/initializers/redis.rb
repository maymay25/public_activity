
begin

  require "redis"
  require "redis-namespace"
  require "redis/objects"

  c = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]

  h = {host: c['host'], port: c['port']}
  h[:password] = c['password'] if c['password'] and c['password']!=""

  Redis::Objects.redis = Redis.new(h)

  #sidekiq_url = "redis://#{c['username']}:#{c['password']}@#{c['host']}:#{c['port']}/#{c['sidekiq_db']}"
  sidekiq_url = "redis://#{c['auth']}#{c['host']}:#{c['port']}/#{c['sidekiq_db']}"
  Sidekiq.configure_server do |config|
    config.redis = { :namespace => 'sidekiq', :url => sidekiq_url }
  end
  Sidekiq.configure_client do |config|
    config.redis = { :namespace => 'sidekiq', :url => sidekiq_url }
  end

rescue

  puts "\n<< condition!!! redis init fail ! \n"

end