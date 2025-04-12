class Discussion < ApplicationRecord
  belongs_to :article
  has_many :discussion_messages
end
