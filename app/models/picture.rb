class Picture < ApplicationRecord
  belongs_to :album, optional: true
  mount_uploader :name, PictureUploader
end
