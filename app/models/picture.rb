class Picture < ApplicationRecord
  belongs_to :album
  mount_uploader :name, PictureUploader
end
