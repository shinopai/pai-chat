class User < ApplicationRecord
  # validation
  validates :name,
            presence: true,
            length: { maximum: 30 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # carrierwave
  mount_uploader :profile_image, ProfileImageUploader

  # relation
  has_one :room
  has_many :messages, dependent: :destroy
  has_many :likes, dependent: :destroy
end
