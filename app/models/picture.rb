class Picture < ApplicationRecord
  belongs_to :album
  mount_uploader :name, PictureUploader
  has_many :users, through: :favorites
end
