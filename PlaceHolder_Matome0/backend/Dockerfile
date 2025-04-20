# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=""

# ---- Build Stage ----
FROM base as build

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      git curl libsqlite3-0 libvips libpq5 cron \
      libffi-dev libreadline-dev libncurses-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Gemfile をコピーしてインストール
COPY Gemfile Gemfile.lock ./

RUN bundle config set --local without '' && \
    GIT_SSL_NO_VERIFY=true bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache

# アプリコードをコピーして bootsnap プリコンパイル
COPY . .

RUN bundle exec bootsnap precompile app/ lib/

# ---- Final Stage ----
FROM base

# 実行時に必要なパッケージ
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      git curl libsqlite3-0 libvips libpq5 cron \
      libffi-dev libreadline-dev libncurses-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# build ステージの内容をコピー
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Git gem のために再度インストール
RUN bundle config set --local without '' && \
    GIT_SSL_NO_VERIFY=true bundle install

# ユーザー設定
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
