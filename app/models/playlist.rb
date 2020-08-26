class Playlist < ApplicationRecord
  belongs_to :album

  validates :name, presence: true
  validates :url, presence: true
  validate :validate_playlist_url

  def validate_playlist_url
    unless url.include?('https://open.spotify.com') || url.include?('https://music.apple.com')
      errors.add(:url, "に登録できるのはSpotifyまたはAppleMusicのプレイリストだけです") 
    end
  end
end
