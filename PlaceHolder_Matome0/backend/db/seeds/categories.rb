# db/seeds/categories.rb

categories = [
  { id: 1, name: '政治', slug: 'politics', description: '国内外の政治に関するニュース' },
  { id: 2, name: '経済', slug: 'economy', description: '経済やビジネスに関するニュース' },
  { id: 3, name: 'テクノロジー', slug: 'technology', description: '最新の技術やITに関するニュース' },
  { id: 4, name: 'エンタメ', slug: 'entertainment', description: '映画、音楽、芸能に関するニュース' },
  { id: 5, name: 'スポーツ', slug: 'sports', description: '国内外のスポーツに関するニュース' },
  { id: 6, name: '健康', slug: 'health', description: '健康や医療に関するニュース' },
  { id: 7, name: 'ゲーム', slug: 'games', description: 'ゲームに関する最新情報' },
  { id: 8, name: 'アニメ', slug: 'anime', description: 'アニメに関するニュースやレビュー' },
  { id: 9, name: 'AI', slug: 'ai', description: '人工知能に関する最新の研究やニュース' },
  { id: 10, name: '芸能', slug: 'celeb', description: '芸能人やエンターテイメントに関するニュース' },
  { id: 11, name: '海外', slug: 'world', description: '海外のニュースや出来事' }
]

categories.each do |category|
  Category.find_or_create_by(name: category[:name]) do |c|
    c.slug = category[:slug]
    c.description = category[:description]
  end
end
