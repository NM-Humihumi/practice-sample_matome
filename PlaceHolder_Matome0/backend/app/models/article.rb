class Article < ApplicationRecord
  has_one :article_metadata, dependent: :destroy
  
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  
  enum status: { draft: 'draft', published: 'published', archived: 'archived' }
  
  # スラッグの自動生成（titleから生成する場合）
  before_validation :generate_slug, on: :create, if: -> { slug.blank? }
  
  # 公開済み記事を取得するスコープ
  scope :published, -> { where(status: 'published').where('published_at <= ?', Time.current) }
  
  # カテゴリ別に記事を取得するスコープ
  scope :by_category, ->(category) { where(category: category) }

  # フロントエンド用にフォーマットされたカテゴリを返す
  def formatted_category
    return nil unless category.present?
    {
      name: category,
      slug: category.downcase.gsub(/\s+/, '-')
    }
  end
  
  private
  
  def generate_slug
    self.slug = title.parameterize if title.present?
  end
end
