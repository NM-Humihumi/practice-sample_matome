discussions = [
  { id: 1, article_id: 1, created_at: Time.current, updated_at: Time.current },
  { id: 2, article_id: 2, created_at: Time.current, updated_at: Time.current },
  { id: 3, article_id: 3, created_at: Time.current, updated_at: Time.current }
]

discussions.each do |discussion_data| 
  unless Discussion.exists?(id: discussion_data[:id])  # 既存のデータを確認
    Discussion.find_or_create_by!(id: discussion_data[:id]) do |discussion|
      discussion.article_id = discussion_data[:article_id]
      discussion.created_at = discussion_data[:created_at]
      discussion.updated_at = discussion_data[:updated_at]
    end 
  end
end
