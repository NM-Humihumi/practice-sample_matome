class ArticleMetadata < ApplicationRecord
  belongs_to :article
  
  validates :article_id, presence: true, uniqueness: true
  
  # タグを配列として取得するメソッド
  def tag_list
    tags.split(',').map(&:strip) if tags.present?
  end
  
  # タグを文字列として設定するメソッド
  def tag_list=(tags_array)
    self.tags = tags_array.join(',') if tags_array.present?
  end
end
