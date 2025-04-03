# 初期記事データ
Article.create!([
  { title: 'Ruby on Rails入門', content: 'Railsの基本を学びましょう' },
  { title: 'Dockerで開発環境構築', content: 'コンテナ化された開発環境のメリット' },
  { title: 'まとめサイトの作り方', content: '人気のまとめサイトを分析' }
])

puts "初期データの投入が完了しました"
