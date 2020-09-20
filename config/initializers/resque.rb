rails_env = ENV.fetch('RAILS_ENV', 'development')
config_file = "#{Rails.root}/config/resque.yml"

resque_config = YAML.load(ERB.new(File.read(config_file)).result)
Resque.redis = Redis.new(resque_config[rails_env])

Resque.logger.formatter = Resque::VeryVerboseFormatter.new