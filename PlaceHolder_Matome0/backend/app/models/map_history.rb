class MapHistory < ApplicationRecord
  # 新しいカラムを追加
  attribute :x, :integer
  attribute :y, :integer
  attribute :before_name, :string
  attribute :after_name, :string
  attribute :before_type, :string
  attribute :after_type, :string
  attribute :before_owner, :string
  attribute :after_owner, :string
  attribute :article_id, :integer
  attribute :created_at, :datetime

  # バリデーションや関連付けが必要な場合はここに追加
end
