article_categories = [
  { article_id: 1, category_id: 9 }, # AI
  { article_id: 1, category_id: 4 }, # エンタメ
  { article_id: 2, category_id: 5 }, # スポーツ
  { article_id: 2, category_id: 1 }, # 政治
  { article_id: 3, category_id: 1 }, # 政治
  { article_id: 3, category_id: 2 }  # 経済
]

article_categories.each do |relation|
  ArticleCategory.find_or_create_by(article_id: relation[:article_id], category_id: relation[:category_id])
end
