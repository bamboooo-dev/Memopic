class Picture < ApplicationRecord
  belongs_to :album
  mount_uploader :picture_name, PictureUploader
end
