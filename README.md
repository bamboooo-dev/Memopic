# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# 開発環境の立ち上げ方

```
$ docker-compose build
$ docker-compose run web bundle exec rails webpacker:install
$ docker-compose run web bundle exec rails db:create
$ docker-compose up
```
