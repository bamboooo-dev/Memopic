class Picture < ApplicationRecord
  belongs_to :album
  mount_uploader :picture_name, PictureUploader
  has_many :favorites, dependent: :destroy
  has_many :favoriters, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
end

  def comments?(picture)
    picture.comments.empty?
  end
