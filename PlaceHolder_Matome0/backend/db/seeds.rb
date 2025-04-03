# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "===== シードデータの読み込みを開始します ====="

# 記事データを読み込み
puts "記事データを読み込んでいます..."
load File.join(Rails.root, 'db', 'seeds', 'articles.rb')

# 必要に応じて他のシードファイルを追加

puts "===== シードデータの読み込みが完了しました ====="
puts "合計 #{Article.count} 件の記事が作成されました"
puts "合計 #{ArticleMetadata.count} 件のメタデータが作成されました"