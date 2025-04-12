class Article < ApplicationRecord
  has_one :article_metadata, dependent: :destroy
  has_many :article_categories, dependent: :destroy
  has_many :categories, through: :article_categories

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  enum status: { draft: 'draft', published: 'published', archived: 'archived' }

  before_validation :generate_slug, on: :create, if: -> { slug.blank? }

  scope :published, -> { where(status: 'published').where('published_at <= ?', Time.current) }

  # カテゴリ名から記事を絞るスコープ（slugやnameに対応させるなどは後ほど調整）
  scope :by_category_name, ->(name) {
    joins(:categories).where(categories: { name: name })
  }

  private

  def generate_slug
    self.slug = title.parameterize if title.present?
  end
end
