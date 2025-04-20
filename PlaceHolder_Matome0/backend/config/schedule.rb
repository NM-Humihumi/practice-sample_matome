# config/schedule.rb

# 明示的に環境変数を渡す（cron環境にはPATHやBUNDLE_PATHが存在しないことがある）
env :PATH, ENV['PATH']
env :BUNDLE_PATH, ENV['BUNDLE_PATH']
env :OPENAI_API_KEY_PATH, ENV['OPENAI_API_KEY_PATH']

set :environment, 'development'
set :output, 'log/cron.log'

every 1.hour, at: '00' do
  # rakeではなく、cdしてbundle execでラップする形に変更（パスが通らないことがあるため）
  command "cd /rails && /usr/local/bin/bundle exec rake generate_news:run RAILS_ENV=development >> log/cron.log 2>&1"
  
end