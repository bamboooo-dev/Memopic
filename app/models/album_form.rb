class AlbumForm
  include ActiveModel::Model

  attr_accessor :name, :picture_name

  validates :name, presence: true

  def save
    return false if invalid?
    album = Album.new(name: name, album_hash: SecureRandom.alphanumeric(20))

    picture_name.each do |picture|
      album.pictures.new(picture_name: picture)
    end
    album.save
    return album
  end
end
