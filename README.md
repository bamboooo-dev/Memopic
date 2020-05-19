# 開発環境の立ち上げ方

```
# イメージの作成
$ docker-compose build

# コンテナの立ち上げ
$ docker-compose up -d

# DB の作成とマイグレーション(DB のコンテナを立ち上げ直すたび)
$ docker-compose exec web rails db:create
$ docker-compose exec web rails db:migrate
```

# テスト方法
```
$ docker-compose exec web rspec
```
# デプロイ方法
```
$ heroku container:push web
$ heroku container:release web

# 必要あれば
$ heroku run rails db:migrate
```
