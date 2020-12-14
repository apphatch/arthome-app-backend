require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ArthomeQcApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoload_paths << Rails.root.join('lib')
    config.hosts << "54.251.164.171"

    config.active_job.queue_adapter = :resque

    # Log rotation, 5 logs, each 10 mb
    config.logger = Logger.new(config.paths["log"].first, 5, 10.megabytes)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
