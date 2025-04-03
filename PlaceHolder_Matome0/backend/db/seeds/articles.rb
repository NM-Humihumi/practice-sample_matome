puts "===== シードデータの読み込みを開始します ====="

puts "データをクリアしています..."
ArticleMetadata.destroy_all if defined?(ArticleMetadata)
Article.destroy_all

puts "記事データを作成しています..."

test_article = Article.create!(
  title: "さまざまなHTML要素を含むテスト記事",
  slug: "html-elements-test",
  content: '
    <h1>大見出し (H1) のサンプル</h1>
    <p>これは通常の段落テキストです。基本的な<strong>強調表示</strong>や<em>イタリック</em>を含んでいます。また、<a href="#">リンク</a>もテストしています。</p>
    <h2>中見出し (H2) のサンプル</h2>
    <p>ここでは別の段落を示しています。文章の途中で<br>改行を入れることもできます。</p>
    <h3>小見出し (H3) のサンプル</h3>
    <ul>
      <li>リストアイテム 1</li>
      <li>リストアイテム 2</li>
      <li>リストアイテム 3 - さらに長いテキストでリストアイテムの表示をテストしています。</li>
    </ul>
    <h2>引用とコードのテスト</h2>
    <blockquote>これは引用文です。著名な言葉や参考文献からの引用をこのように表示できます。</blockquote>
    <pre><code>// これはコードブロックです
function testFunction() {
  console.log("Hello, World!");
}
</code></pre>
    <h2>画像テスト</h2>
    <figure>
      <img src="/images/sample.jpg" alt="サンプル画像の代替テキスト">
      <figcaption>画像のキャプション例</figcaption>
    </figure>
    <h2>表のテスト</h2>
    <table>
      <thead>
        <tr><th>ヘッダー1</th><th>ヘッダー2</th><th>ヘッダー3</th></tr>
      </thead>
      <tbody>
        <tr><td>行1, セル1</td><td>行1, セル2</td><td>行1, セル3</td></tr>
        <tr><td>行2, セル1</td><td>行2, セル2</td><td>行2, セル3</td></tr>
      </tbody>
    </table>
    <h2>まとめ</h2>
    <p>これはさまざまなHTML要素の表示をテストするための記事でした。</p>
  ',
  status: "published",
  category: "テスト",
  author: "開発者",
  published_at: Time.current - 5.days
)
puts "作成: #{test_article.title}"

tech_article = Article.create!(
  title: "新型AI「MindWave」が人間の思考を理解する新技術を開発",
  slug: "ai-mindwave-understands-human-thoughts",
  content: '
    <h1>新型AI「MindWave」が人間の思考を理解する新技術を開発</h1>
    <p class="lead">テクノロジー企業TechFrontierは本日、人間の思考パターンをリアルタイムで分析できる革新的なAIシステム「MindWave」を発表しました。</p>
    <h2>脳波解析の新たなブレイクスルー</h2>
    <p>MindWaveは非侵襲的な脳波スキャン技術と最先端の機械学習アルゴリズムを組み合わせることで、ユーザーの思考パターンを95%以上の精度で解読することができます。</p>
    <h2>医療分野での応用に期待</h2>
    <p>専門家たちはこの技術が特に医療分野で大きな可能性を秘めていると指摘しています。</p>
    <blockquote>「コミュニケーション障害を持つ患者さんのための革命的なツールになる可能性があります。」</blockquote>
    <h2>倫理的な懸念も</h2>
    <p>一方で、プライバシーや倫理に関する懸念も表明されています。</p>
    <h2>市場投入計画</h2>
    <p>MindWaveは来年初頭に医療向けバージョンが限定的にリリースされる予定です。</p>
  ',
  status: "published",
  category: "テクノロジー",
  author: "山本太郎",
  published_at: Time.current - 2.days
)
puts "作成: #{tech_article.title}"

science_article = Article.create!(
  title: "南太平洋で新種の深海生物「ルミナス・アビサリス」を発見",
  slug: "new-deep-sea-creature-discovered",
  content: '
    <h1>南太平洋で新種の深海生物「ルミナス・アビサリス」を発見</h1>
    <p class="lead">国際海洋調査チームは、マリアナ海溝近くの水深8,200メートルで、これまでに見たことのない発光する深海生物を発見しました。</p>
    <h2>前例のない生物学的特徴</h2>
    <p>全長約30センチのルミナス・アビサリスは、透明なゼラチン質の体と、驚くべき発光能力を持っています。体全体が7色に輝き、その光のパターンは複雑なシーケンスで変化することが観測されました。</p>
    <figure>
      <img src="/images/luminous-abyssalis.jpg" alt="ルミナス・アビサリスの発光の様子">
      <figcaption>深海探査機が撮影したルミナス・アビサリスの発光の様子</figcaption>
    </figure>
    <h2>進化の謎</h2>
    <p>この生物のDNA分析結果には、これまで地球上で確認されていないパターンが含まれています。</p>
    <h2>今後の研究計画</h2>
    <p>研究チームはより詳細な解析と生理学的研究を進める予定です。</p>
  ',
  status: "published",
  category: "科学",
  author: "鈴木海",
  published_at: Time.current - 1.day
)
puts "作成: #{science_article.title}"

draft_article = Article.create!(
  title: "地球温暖化対策における最新技術トレンド【執筆中】",
  slug: "climate-change-technology-trends-draft",
  content: '
    <h1>地球温暖化対策における最新技術トレンド</h1>
    <p class="lead">※この記事は現在執筆中です※</p>
    <h2>二酸化炭素の直接回収技術</h2>
    <p>（ここに内容を追加予定）</p>
    <h2>再生可能エネルギーの統合型ソリューション</h2>
    <p>（ここに内容を追加予定）</p>
  ',
  status: "draft",
  category: "環境",
  author: "緑川エコ",
  published_at: nil
)
puts "作成: #{draft_article.title}"

puts "記事データの作成が完了しました！"

puts "記事メタデータを作成しています..."

ArticleMetadata.create!(
  article: test_article,
  summary: "このテスト記事ではさまざまなHTML要素（見出し、段落、リスト、表など）の表示を確認できます。",
  image_url: "/images/test-article-main.jpg",
  thumbnail_url: "/images/test-article-thumb.jpg",
  tags: "テスト,HTML,マークアップ,開発",
  reading_time: 3,
  featured: true,
  meta_title: "HTML要素テスト - フロントエンド開発者向け",
  meta_description: "この記事はHTML要素の表示テスト用に作成されました。さまざまなマークアップ要素を含んでいます。"
)

ArticleMetadata.create!(
  article: tech_article,
  summary: "テクノロジー企業TechFrontierが開発した新型AI「MindWave」は人間の思考を高精度で理解できる画期的な技術として注目を集めています。",
  image_url: "/images/mindwave-main.jpg",
  thumbnail_url: "/images/mindwave-thumb.jpg",
  tags: "AI,テクノロジー,脳科学,医療,倫理",
  reading_time: 5,
  featured: true,
  view_count: 1250,
  meta_title: "MindWave: 思考を読み取る革新的AI技術",
  meta_description: "人間の思考を理解するAI「MindWave」の最新技術と応用分野、倫理的懸念について解説します。"
)

ArticleMetadata.create!(
  article: science_article,
  summary: "マリアナ海溝で発見された新種の発光深海生物「ルミナス・アビサリス」は、地球上で確認されていない遺伝パターンを持ち科学界に衝撃を与えています。",
  image_url: "/images/deep-sea-creature-main.jpg",
  thumbnail_url: "/images/deep-sea-creature-thumb.jpg",
  tags: "海洋生物学,深海,新種発見,科学ニュース,マリアナ海溝",
  reading_time: 6,
  featured: true,
  view_count: 3200,
  meta_title: "新種の深海生物「ルミナス・アビサリス」の驚くべき特徴",
  meta_description: "未知の生物「ルミナス・アビサリス」の特徴と科学的意義について解説。"
)

ArticleMetadata.create!(
  article: draft_article,
  summary: "地球温暖化対策として注目される最新技術トレンドをまとめた記事です。",
  tags: "気候変動,テクノロジー,サステナビリティ,カーボンニュートラル",
  reading_time: 8,
  featured: false,
  meta_title: "2025年注目の気候変動対策技術トレンド分析",
  meta_description: "地球温暖化対策として開発が進む最新技術トレンドを紹介。"
)

puts "記事メタデータの作成が完了しました！"
puts "===== シードデータの読み込みが完了しました ====="
puts "合計 #{Article.count} 件の記事が作成されました"
puts "合計 #{ArticleMetadata.count} 件のメタデータが作成されました"
