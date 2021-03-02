# if we get connection error start redis manually from terminal before, redis-server

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://localhost:6379/0" }
end
Sidekiq.configure_client do |config|
  config.redis = { url: "redis://localhost:6379/0" }
end
