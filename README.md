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

## HTTPS migration notes

S3の静的サイトホスティング単体では、独自ドメイン（`designgineer.io`）でのHTTPS終端はできません。`https://designgineer.io` を安定運用するには、以下の構成が必要です。

1. ACM（`us-east-1`）で `designgineer.io` と `www.designgineer.io` の証明書を発行
2. CloudFront Distribution を作成し、S3バケットをオリジンに設定
3. Alternate Domain Names (CNAMEs) に `designgineer.io` / `www.designgineer.io` を設定
4. Route53 で `A/AAAA (Alias)` を CloudFront に向ける
5. CloudFront Function または Behavior 設定で HTTP -> HTTPS リダイレクトを有効化

このリポジトリ側では、ページ内リンク・外部参照URLをHTTPS前提へ更新済みです。
