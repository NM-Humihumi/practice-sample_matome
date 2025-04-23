# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.0
FROM docker.io/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=""

# ---- Build Stage ----
FROM base as build

# ビルドに必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      curl \
      libpq-dev \
      zlib1g-dev \
      libssl-dev \
      libreadline-dev \
      libyaml-dev \
      libxml2-dev \
      libxslt1-dev \
      libffi-dev \
      libncurses-dev \
      postgresql-client \
      tzdata \
      cron && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo "Asia/Tokyo" > /etc/timezone && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Gemfileをコピーしてインストール
COPY Gemfile Gemfile.lock ./

# Bundler設定とgemインストール
RUN bundle config set --local without '' && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache

# アプリコードをコピーしてbootsnapプリコンパイル
COPY . .

RUN bundle exec bootsnap precompile app/ lib/

# ---- Final Stage ----
FROM base

# 実行時に必要なパッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libpq5 \
      libsqlite3-0 \
      libvips \
      postgresql-client \
      tzdata \
      cron && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo "Asia/Tokyo" > /etc/timezone && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# ビルドステージからBundlerとアプリをコピー
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# ユーザー作成
RUN useradd rails --create-home --shell /bin/bash

# エントリーポイントスクリプトをコピー
COPY entrypoint.sh /rails/entrypoint.sh
RUN chmod +x /rails/entrypoint.sh

USER rails

# ポート公開
EXPOSE 3001

# エントリーポイントを使用
ENTRYPOINT ["/rails/entrypoint.sh"]
CMD ["sh", "-c", "bundle exec rails server -p 3001 -b 0.0.0.0"]