class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_albums
  has_many :albums, through: :user_albums
  has_many :favorites
  has_many :favoring, through: :favorites, source: :picture
  has_many :comments, dependent: :destroy
  has_many :pictures, through: :favorites
  has_many :pictures, through: :comments
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  include DeviseTokenAuth::Concerns::User

  devise :omniauthable, omniauth_providers: %i[google_oauth2 line]

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    email = auth.info.email ? auth.info.email : "#{uid}-#{provider}@example.com"
    user = User.where(email: email, uid: uid, provider: provider).first
    unless user.present?
      user = User.new(
        nickname: auth.info.name,
        email: email,
        uid: uid,
        provider: provider
      )
    end
    return { user: user }
  end

  def favor(picture)
    favoring << picture
  end

  def favoring?(picture)
    favoring.include?(picture)
  end

  def unfavor(picture)
    favorites.find_by(picture_id: picture.id).destroy
  end

  def join(album)
    albums << album
  end

  def joining?(album)
    albums.include?(album)
  end

  def commented?(comment)
    comments.includes?(comment)
  end
end
