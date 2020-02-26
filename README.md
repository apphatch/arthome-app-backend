# README

1. Install Ruby 2.7.0. We suggest using RVM. On Mac:
```
brew install rvm
rvm install 2.7.0
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
