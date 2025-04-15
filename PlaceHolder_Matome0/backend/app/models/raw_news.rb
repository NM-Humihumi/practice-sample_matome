class RawNews < ApplicationRecord
  validates :title, presence: true
  validates :external_id, presence: true, uniqueness: true
  validates :source_type, presence: true
end
