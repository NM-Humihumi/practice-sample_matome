# db/seeds/articles_seeds.rb

articles = [
  {
    id: 1,
    title: 'OpenAIがGPT-5を今夏リリース予定',
    slug: 'openai-gpt5-release-summer',
    status: 'published',
    author: 'news_bot',
    published_at: Time.current,
    digest: <<~TEXT.strip,
      OpenAIは次世代AIモデル「GPT-5」を2025年夏にリリース予定と発表。
      性能・安全性ともに大幅な向上が期待されている。
      現時点での詳細は未発表だが、業界からの注目が集まっている。
    TEXT
    discussion_id: nil
  },
  {
    id: 2,
    title: 'Amazon、AI活用で物流効率20%向上',
    slug: 'amazon-ai-logistics-boost',
    status: 'published',
    author: 'news_bot',
    published_at: 1.day.ago,
    digest: <<~TEXT.strip,
      Amazonが新たに導入したAI物流システムにより、
      配送効率が20%改善されたと報告された。
      今後は他国への展開も計画されている。
    TEXT
    discussion_id: nil
  },
  {
    id: 3,
    title: 'EU、AI法案を正式採択',
    slug: 'eu-ai-law-adopted',
    status: 'published',
    author: 'news_bot',
    published_at: 2.days.ago,
    digest: <<~TEXT.strip,
      欧州連合（EU）がAI規制法案を正式に採択。
      高リスクAIの使用には厳格な基準が課される。
      企業は法的準拠への対応が求められることに。
    TEXT
    discussion_id: nil
  }
]

articles.each do |article_data|
  Article.create!(article_data)
end
