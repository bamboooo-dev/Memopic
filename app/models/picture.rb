class Picture < ApplicationRecord
  belongs_to :album
  mount_uploader :picture_name, PictureUploader
  has_many :users, through: :favorites
end
