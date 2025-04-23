require 'openai'

namespace :generate_news do
  desc "Generate news"
  task run: :environment do
    Rails.logger.info "News generation task executed at #{Time.now}"

    # 環境変数からキーのパスを取得
    api_key_path = ENV["OPENAI_API_KEY_PATH"]

    # ファイルからAPIキーを読み取る
    api_key = File.read(api_key_path).strip

    OpenAI.configure do |config|
      config.access_token = api_key
    end

    client = OpenAI::Client.new

    # ファイル読み込み
    prompt_text = File.read(Rails.root.join("prompts", "generate_news_prompt.txt"))
    background = File.read(Rails.root.join("prompts", "world", "background.txt"))

    # MapTile テーブルから全マスのデータを取得してJSON化
    map_data = MapTile.all.map do |tile|
      {
        x: tile.x,
        y: tile.y,
        name: tile.name,
        type: tile.tile_type,
        owner: tile.owner
      }
    end.to_json

    # APIに渡すメッセージを構築
    messages = [
      { role: "system", content: background },
      {
        role: "user",
        content: "#{prompt_text}\n\n#{map_data}"
      }
    ]

    # API呼び出し
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: messages,
        temperature: 0.7
      }
    )

    # 結果の整形とDB登録
    raw_content = response.dig("choices", 0, "message", "content")
    cleaned_content = raw_content.gsub(/```json|```/, "").strip

    begin
      json = JSON.parse(cleaned_content)
    
      title = json["title"].to_s.strip.presence || "無題の記事"
      slug_base = title.parameterize.presence || "untitled-#{SecureRandom.hex(4)}"
    
      Article.create!(
        title: title,
        digest: json["digest"] || "要約なし",
        author: json["author"] || "匿名",
        slug: slug_base,
        published_at: Time.current,
        status: "published"
      )
    
      Rails.logger.info "News created: #{title}"
    rescue JSON::ParserError => e
      Rails.logger.error "JSON parse failed: #{e.message}"
      Rails.logger.error "Raw content: #{raw_content}"
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "DB insert failed: #{e.message}"
      Rails.logger.error "Parsed JSON: #{json.inspect}"
    end    
  end
end
