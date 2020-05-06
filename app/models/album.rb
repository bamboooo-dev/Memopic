class Album < ApplicationRecord
  has_many :pictures, dependent: :destroy
  has_many :user_albums
  has_many :users, through: :user_albums
  validates :name, presence: true
end
