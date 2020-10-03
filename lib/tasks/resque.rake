# Resque tasks
require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  task :setup => :environment do
    Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")

    ENV['QUEUES'] = 'default,sleep,run,import'
  end
end
