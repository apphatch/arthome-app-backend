# Install server Ubuntu 18.04 with Passenger + Nginx

## Update apt
```
sudo apt-get update
```

## Get rvm
```
curl -L get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm requirements
```

## Get ruby 2.6.3 and bundler
```
rvm install 2.6.3
gem install bundler:2.1.4
```

## Setup PostgreSQL 10.4
```
sudo apt install postgresl postgresql-contrib
sudo apt-get install libpq-dev
```

## Clone and setup repo
```
bundle install
```

## Setup DB
change pg_hba.conf to authenticate md5 (usually in /etc/postgresql/10/main/)

login as postgres
```
sudo --login --user postgres
psql
```
create user (match rails database.yml)
```
CREATE USER username WITH PASSWORD 'password';
ALTER ROLE username WITH CREATEDB REPLICATION LOGIN;
```
create rails db
```
RAILS_ENV=production rake db:create db:migrate
```

## Install nginx with passenger
use rvmsudo to have passenger install nginx
install dependencies as instructed, then rerun if required
```
rvmsudo passenger-install-nginx-module
```
nginx will get installed into /opt/nginx

## Configure nginx
configure the /opt/nginx/conf/nginx.conf (skip for now)
then to start nginx
```
sudo /opt/nginx/sbin/nginx
```
to stop, use
```
ps auxw | grep nginx
sudo kill {pid}
```
or the one-liner
```
sudo kill $(cat /opt/nginx/logs/nginx.pid)
```
refer => https://www.phusionpassenger.com/library/install/nginx/install/oss/rubygems_rvm/

## Configure passenger
you may need to add daemonize to Passengerfile.json
run passenger daemon
```
bundle exec passenger start
```
to stop
```
bundle exec passenger stop
```
