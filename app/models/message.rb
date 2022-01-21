class Message < ApplicationRecord
  # relation
  belongs_to :user
  belongs_to :room
  has_many :likes, dependent: :destroy

  # validation
  validates :body,
            presence: true,
            length: { maximum: 100 }
end
