Resque.redis = $redis
Resque.logger = Logger.new("#{Rails.root}/log/resque.log")
Resque.logger.formatter = Resque::VeryVerboseFormatter.new
