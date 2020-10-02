Setup Notes
========================

[![Redis][redis-image]][redis-link]

Redis
-----

## Getting started
### Install Redis Server
- For MacOS
  ---
  Step 1:
  ```
    install :    brew install redis
    start   :    brew services start redis
    stop    :    brew services stop redis
  ```
  Step 2: Configs(Optional) - Follow link
  ```
    https://medium.com/@petehouston/install-and-config-redis-on-mac-os-x-via-homebrew-eb8df9a4f298
  ```
- For Ubuntu
  ---
  Step 1:
  ```
    sudo apt update
    sudo apt install redis-server
  ```
  Step 2: Configs(Optional) - Follow Link
    ```
      https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04
    ```
## Gem Install
  ```
    # Use Redis adapter to run Action Cable in production
    gem 'redis', '~> 4.0'
  ```
## Create file /initializes/redis.rb
  redis.rb
  ```
    require "redis"

    $redis = Redis.new({
      host: localhost,
      port: 6379,
      connect_timeout: 0.2,
      read_timeout: 1.0,
      write_timeout: 0.5
    })

  ```

## Start Redis
```
  redis-server
```
======
Resque
======

[![Gem Version](https://badge.fury.io/rb/resque.svg)](https://rubygems.org/gems/resque)
[![Build Status](https://travis-ci.org/resque/resque.svg)](https://travis-ci.org/resque/resque)

## Install
  ```
    # Use resque for jobs
    gem 'resque', '~> 2.0'
    # Light weight job scheduling on top of Resque
    gem 'resque-scheduler', '~> 4.4'

  ```
## Start Resque
  ```
    ## Create file /initializes/resque.rb

    # Add two line to this file
    Resque.redis = $redis
    Resque.logger.formatter = Resque::VeryVerboseFormatter.new

  ```
## Create file /configs/resque_schedule.yml
  ```
    sleep:
      every: 30s
      class: Sleeper
      args:
      queue: high
      description: Runs the perform method in Sleeper
  ```
## Create lib/task/resque.rake
  ```
    # Resque tasks
    require 'resque/tasks'
    require 'resque/scheduler/tasks'

    namespace :resque do
      task :setup => :environment do
        Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")

        ENV['QUEUES'] = 'default,sleep,run'
      end
    end
  ```

## Update routes to use resque management interface
  ```
    require 'resque/server'
    require 'resque/scheduler'
    require 'resque/scheduler/server'

    Rails.application.routes.draw do
      mount Resque::Server.new, at: "/resque"
    end
  ```

## Access to web management
  ```
    http://localhost:3000/resque
  ```

  ## License
  The code is available at [GitHub][home] under the [MIT license][license].

  [bps10]: https://github.com/bps10
  [gfm-api]: https://developer.github.com/v3/markdown/
  [glfm-api]: https://docs.gitlab.com/ee/api/markdown.html
  [hexatrope]: https://github.com/hexatrope
  [home]: https://github.com/revolunet/sublimetext-markdown-preview
  [hozaka]: https://github.com/hozaka
  [hadisfr]: https://github.com/hadisfr
  [issue]: https://github.com/facelessuser/MarkdownPreview/issues
  [license]: http://revolunet.mit-license.org
  [live-reload]: https://packagecontrol.io/packages/LiveReload
  [pymd]: https://github.com/Python-Markdown/markdown
  [pymdownx-docs]: http://facelessuser.github.io/pymdown-extensions/usage_notes/
  [tommi]: https://github.com/tommi
  [travis-image]: https://img.shields.io/travis/facelessuser/MarkdownPreview/master.svg
  [travis-link]: https://travis-ci.org/facelessuser/MarkdownPreview
  [pc-image]: https://img.shields.io/packagecontrol/dt/MarkdownPreview.svg
  [pc-link]: https://packagecontrol.io/packages/MarkdownPreview
  [license-image]: https://img.shields.io/badge/license-MIT-blue.svg
  [redis-image]: https://redis.io/images/redis-white.png
  [redis-link]: https://github.com/redis/redis-rb