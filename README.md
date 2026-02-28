# Designgineer.io

`designgineer.io` の静的サイトです（Middlemanベース）。

## Ruby

このリポジトリは `rbenv` の `Ruby 4.0.1` を前提にしています（`.ruby-version` 参照）。

## Local development

```bash
bundle install
bundle exec middleman server
```

## Build

```bash
bundle exec middleman build
```

## Deploy to S3

1. `.env.sample` をコピーして `.env` を作成
2. `S3_ACCESS` / `S3_SECRET` を設定
3. 次を実行

```bash
BUNDLE_WITH=deploy bundle install
BUNDLE_WITH=deploy bundle exec middleman s3_sync
```

## HTTPS migration

S3静的サイトホスティング単体では、独自ドメインでのHTTPS終端はできません。
`designgineer.io` は `S3 + CloudFront + ACM` 構成で運用します。

実施手順は以下を参照してください。

- [`docs/https-migration.md`](docs/https-migration.md)
- [`infrastructure/cloudfront/viewer-request-redirect.js`](infrastructure/cloudfront/viewer-request-redirect.js)
