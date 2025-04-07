# syntax = docker/dockerfile:1

# Ruby のバージョンが .ruby-version ファイルと Gemfile に一致していることを確認
ARG RUBY_VERSION=3.2.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails アプリケーションのディレクトリ
WORKDIR /rails

# 開発環境設定
# RAILS_ENV: Railsの実行環境を開発モードに設定
# BUNDLE_PATH: gemのインストール先を指定
# BUNDLE_WITHOUT: 空にして全てのgemをインストール
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=""

# ビルド用の一時的なステージ（最終イメージのサイズを減らすため）
FROM base as build

# 開発ツールをインストール - これが重要です
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

# gemをビルドするために必要なパッケージをインストール
# libpq-dev: PostgreSQLの開発ライブラリ（pg gemのビルドに必要）
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config libpq-dev

# アプリケーションのgemをインストール
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without '' && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# アプリケーションコードをコピー
COPY . .

# 起動時間を高速化するためにbootsnapコードをプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/

# アプリケーションイメージの最終ステージ
FROM base

# デプロイに必要なパッケージをインストール
# libpq5: PostgreSQLクライアントライブラリ（実行時に必要）
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0 libvips libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ビルドステージから生成物（gems, アプリケーション）をコピー
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# セキュリティのため、ランタイムファイルだけを非root権限で実行
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# デフォルトでサーバーを起動（実行時に上書き可能）
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]