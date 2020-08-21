class AlbumForm
  include ActiveModel::Model

  attr_accessor :name, :pictures

  validates :name, presence: true

  def save(user)
    return false if invalid?
    album = Album.new(name: name, album_hash: SecureRandom.alphanumeric(20))

    return false if pictures.nil?
    
    pictures.each_with_index do |picture, index|
      album.pictures.new(picture_name: picture)
      ProgressChannel.broadcast_to(
        user,
        percent: (index+1) * 100 / pictures.length
      )
    end
    album.save
    album.users << user
    return album
  end

  def update(album)
    if album.update(name: name)
      return true if pictures.nil?
      pictures.each do | picture |
        album.pictures.new(picture_name: picture)
      end
      album.save
      return true
    else
      return false
    end
  end
end
