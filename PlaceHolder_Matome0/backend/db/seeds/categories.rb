# カテゴリの初期データを作成します
categories = [
  { id: 1, name: '政治', description: '国内外の政治に関するニュース' },
  { id: 2, name: '経済', description: '経済やビジネスに関するニュース' },
  { id: 3, name: 'テクノロジー', description: '最新の技術やITに関するニュース' },
  { id: 4, name: 'エンタメ', description: '映画、音楽、芸能に関するニュース' },
  { id: 5, name: 'スポーツ', description: '国内外のスポーツに関するニュース' },
  { id: 6, name: '健康', description: '健康や医療に関するニュース' },
  { id: 7, name: 'ゲーム', description: 'ゲームに関する最新情報' },
  { id: 8, name: 'アニメ', description: 'アニメに関するニュースやレビュー' },
  { id: 9, name: 'AI', description: '人工知能に関する最新の研究やニュース' },
  { id: 10, name: '芸能', description: '芸能人やエンターテイメントに関するニュース' },
  { id: 11, name: '海外', description: '海外のニュースや出来事' }
]

categories.each do |category|
  Category.find_or_create_by(name: category[:name]) do |c|
    c.description = category[:description]
  end
end
