require "redis"

redis_config = YAML::load(ERB.new(File.read(Rails.root.join("config", "redis.yml"))).result)
redis_default = redis_config[ENV.fetch('RAILS_ENV', 'development')].symbolize_keys

$redis = Redis.new(redis_default)
