#!/bin/bash

# デバッグログを有効化
set -x
# エラーハンドリングを無効化
set +e

echo "Starting entrypoint.sh..."

# /tmp/railsディレクトリを準備
echo "Creating /tmp/rails directories..."
mkdir -p /tmp/rails/pids /tmp/rails/cron || true
chown rails:rails /tmp/rails/pids /tmp/rails/cron || echo "Failed to chown /tmp/rails directories, continuing..."
touch /tmp/rails/cron/cron.log || true
chown rails:rails /tmp/rails/cron/cron.log || echo "Failed to chown cron.log, continuing..."

# Wheneverでcrontabを更新
echo "Updating crontab with whenever..."
bundle exec whenever --update-crontab || echo "Failed to update crontab, continuing..."

# Cronを非rootでバックグラウンド起動（ログ有効）
echo "Starting cron..."
cron -f -L 15 || echo "Failed to start cron, continuing..." &

# サーバーのPIDファイルを削除
echo "Removing server.pid..."
rm -f /tmp/rails/pids/server.pid || echo "Failed to remove server.pid, continuing..."

# データベースを準備（作成＋マイグレーション）
echo "Running db:prepare..."
bundle exec rails db:prepare || echo "Failed to run db:prepare, continuing..."

# シードデータを実行
echo "Running db:seed..."
bundle exec rails db:seed || echo "Failed to run db:seed, continuing..."

# Railsサーバーを起動
echo "Starting rails server..."
exec "$@" || echo "Failed to start rails server"