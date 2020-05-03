class AlbumForm
  include ActiveModel::Model

  attr_accessor :name, :picture_name

  validates :name, presence: true

  def save
    return false if invalid?
    album = Album.new(name: name, album_hash: SecureRandom.alphanumeric(20))
    album.pictures.new(picture_name: picture_name)
    album.save
    return album
  end
end
