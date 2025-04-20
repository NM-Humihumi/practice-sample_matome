class MapTile < ApplicationRecord
  validates :x, presence: true
  validates :y, presence: true
  validates :tile_type, presence: true, inclusion: { in: %w[plain forest mountain ocean] }
end
