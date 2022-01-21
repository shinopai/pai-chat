class Like < ApplicationRecord
  # relation
  belongs_to :user
  belongs_to :message
end
