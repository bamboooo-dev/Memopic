class AlbumForm < ApplicationRecord
  include ActiveModel::Model

  attr_accessor :name, :album_hash, :picture_name

  validates :name, :album_hash, presence: true

  def save
    return false if invalid?

    album = Album.new(name: name, album_hash: album_hash)
    album.pictures.new(picture_name: picture_name)
    album.save
  end
end
