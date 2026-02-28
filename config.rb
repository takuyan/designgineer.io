require 'dotenv'
Dotenv.load

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :build_dir, 'build'

configure :development do
  activate :livereload
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

if defined?(Middleman::S3Sync)
  activate :s3_sync do |s3_sync|
    s3_sync.bucket                     = 'designgineer.io'
    s3_sync.aws_access_key_id          = ENV['S3_ACCESS']
    s3_sync.aws_secret_access_key      = ENV['S3_SECRET']
    s3_sync.prefer_gzip                = true
    s3_sync.path_style                 = true
    s3_sync.reduced_redundancy_storage = false
    s3_sync.acl                        = 'public-read'
    s3_sync.encryption                 = false
  end
end
