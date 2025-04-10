speakers = [
  { name: "Moody", color_code: "#000000" },  # 黒色
  # 他のスピーカーを追加する場合はここに記述
]

speakers.each do |speaker_data|
  Speaker.find_or_create_by!(name: speaker_data[:name]) do |speaker|
    speaker.color_code = speaker_data[:color_code]
    # その他のカラムはデフォルト(nil)のままでOK
  end
end
