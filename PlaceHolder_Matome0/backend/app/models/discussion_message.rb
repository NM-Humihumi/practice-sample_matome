class DiscussionMessage < ApplicationRecord
  belongs_to :discussion
  belongs_to :speaker
end
