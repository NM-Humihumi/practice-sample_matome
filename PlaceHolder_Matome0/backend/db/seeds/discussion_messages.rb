discussion_messages = [
  { discussion_id: 1, speaker_id: 1, content: "AIは今後どのように進化すると思いますか？", position: 1 },
  { discussion_id: 1, speaker_id: 1, content: "AIの倫理的な側面についても考慮する必要があります。", position: 2 },
  { discussion_id: 2, speaker_id: 1, content: "テクノロジーは常に進化していますが、どの分野が最も影響を受けるでしょうか？", position: 1 },
  { discussion_id: 3, speaker_id: 1, content: "スポーツの未来はテクノロジーによって大きく変わるでしょう。", position: 1 }
]

discussion_messages.each do |message_data|
  DiscussionMessage.find_or_create_by!(discussion_id: message_data[:discussion_id], speaker_id: message_data[:speaker_id]) do |message|
    message.content = message_data[:content]
    message.position = message_data[:position]
  end
end
