class DiscussionMessage < ApplicationRecord
  belongs_to :speaker
  belongs_to :discussion
  belongs_to :speaker
end
