namespace :import do
  desc 'Import news from NewsCast API'
  task newscast: :environment do
    require 'net/http'
    require 'json'
    require 'uri'

    # APIキーを読み込む
    api_key = File.read('config/credential/newscast.txt').strip

    # NewsCast APIのURL
    url = URI.parse('https://newscast.jp/api/v3/news/bulk')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    # GETリクエストを送信
    request = Net::HTTP::Get.new(url.request_uri)
    request['Authorization'] = "Bearer #{api_key}"

    response = http.request(request)
    results = JSON.parse(response.body)['results']

    results.each do |item|
      external_id = item['code']

      # 同一のexternal_idが存在する場合はスキップ
      next if RawNews.exists?(external_id: external_id)

      # RawNewsを作成
      RawNews.create!(
        title: item['title'],
        body: item['news_items'].map { |news_item| news_item['content'] if news_item['type'] == 'text' }.compact.join("\n"),
        source_url: item['publisher']['url'],
        image_url: item['attachment_image_url'],
        published_at: item['open_datetime'],
        author: item['publisher']['name'] || item['publisher']['profile']['company_name'],
        external_id: external_id,
        source_type: 'newscast',
        converted_to_article: false
      )
    end
  end
end
