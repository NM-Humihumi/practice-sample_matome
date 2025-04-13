discussion_messages = [
  { article_id: 1, speaker_id: 1, content: "AIは今後どのように進化すると思いますか？", position: 1 },
  { article_id: 1, speaker_id: 1, content: "AIの倫理的な側面についても考慮する必要があります。", position: 2 },
  { article_id: 2, speaker_id: 1, content: "テクノロジーは常に進化していますが、どの分野が最も影響を受けるでしょうか？", position: 1 },
  { article_id: 3, speaker_id: 1, content: "スポーツの未来はテクノロジーによって大きく変わるでしょう。", position: 1 }
]

discussion_messages.each do |data| 
  discussion = Discussion.find_by(article_id: data[:article_id])
  next unless discussion

  unless DiscussionMessage.exists?(discussion_id: discussion.id, speaker_id: data[:speaker_id], position: data[:position])  # 既存のデータを確認
    DiscussionMessage.find_or_create_by!(
      discussion_id: discussion.id,
      speaker_id: data[:speaker_id],
      position: data[:position]
    ) do |message|
      message.content = data[:content]
    end
  end
end
