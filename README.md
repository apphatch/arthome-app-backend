# README

## Installation
1. Uses Ruby 2.6.3. We suggest using RVM. On Mac:
```
brew install rvm
rvm install 2.6.3
```

2. This repo requires PostgreSQL 9.5.20.

3. Setup config/database.yml for your DB.

4. Migrate the DB.
```
rake db:setup
```

5. Run the server
```
rails server
```

6. Run production server
```
bundle exec passenger start
```

## Things to check after a server restart
1. Redis should be running
```
redis-server
```
