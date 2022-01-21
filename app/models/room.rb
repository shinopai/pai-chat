class Room < ApplicationRecord
  # realtion
  belongs_to :user
  has_many :messages, dependent: :destroy
end
