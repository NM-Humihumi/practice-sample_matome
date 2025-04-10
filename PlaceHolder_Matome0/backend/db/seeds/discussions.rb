discussions = [
  { id: 1, article_id: 1, created_at: Time.current, updated_at: Time.current },
  { id: 2, article_id: 2, created_at: Time.current, updated_at: Time.current },
  { id: 3, article_id: 3, created_at: Time.current, updated_at: Time.current }
]

discussions.each do |discussion_data|
  Discussion.create!(discussion_data)
end
