require 'exifr/jpeg'
require 'exifr/tiff'

class AlbumForm
  include ActiveModel::Model

  attr_accessor :name, :pictures, :playlist_name, :playlist_url

  validates :name, presence: true

  def save(user)
    return false if invalid?
    album = Album.new(name: name, album_hash: SecureRandom.alphanumeric(20))

    return false if pictures.nil?

    pictures.each_with_index do |picture, index|
      lat, lng, date_time = get_exif_info(picture)
      album.pictures.new(picture_name: picture, latitude: lat, longitude: lng, taken_at: date_time)
      ProgressChannel.broadcast_to(
        user,
        percent: (index+1) * 100 / pictures.length
      )
    end
    album.save

    album.users << user

    if playlist_name && playlist_url
      playlist = Playlist.create(name: playlist_name, url: playlist_url)
      album.playlists << playlist
    end

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

  private
    def get_exif_info(picture)
      begin
        ext = File.extname(picture.tempfile).downcase
        if ext == '.jpg' || ext == '.jpeg'
          exif = EXIFR::JPEG::new(picture.tempfile)
          lat = exif.gps.latitude
          lng = exif.gps.longitude
          date_time = exif.date_time
        elsif ext == '.tif' || ext == '.tiff'
          exif = EXIFR::TIFF::new(picture.tempfile)
          lat = exif.gps.latitude
          lng = exif.gps.longitude
          date_time = exif.date_time
        end
      rescue NoMethodError
        lat, lng, date_time = nil
      end

      return lat, lng, date_time 
    end
end
