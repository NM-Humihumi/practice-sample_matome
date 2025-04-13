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

seed_files = Dir[Rails.root.join('db', 'seeds', '*.rb')].sort

seed_files.each do |seed_file|
  puts "→ #{File.basename(seed_file)} を読み込み中..."
  load seed_file
end

puts "===== シードデータの読み込みが完了しました ====="
puts "合計 #{Article.count} 件の記事が作成されました"
puts "合計 #{ArticleMetadata.count} 件のメタデータが作成されました"
puts "合計 #{Category.count} 件のカテゴリが作成されました"
puts "合計 #{ArticleCategory.count} 件のカテゴリマッピングが作成されました"
puts "合計 #{Speaker.count} 件のスピーカーが作成されました"
puts "合計 #{Discussion.count} 件のディスカッションが作成されました"
puts "合計 #{DiscussionMessage.count} 件のディスカッションメッセージが作成されました"
