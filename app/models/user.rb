class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :sns_credentials, dependent: :destroy
  has_many :user_albums
  has_many :albums, through: :user_albums
  has_many :favorites
  has_many :favoring, through: :favorites, source: :picture
  has_many :comments, dependent: :destroy
  has_many :pictures, through: :favorites
  has_many :pictures, through: :comments
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable,
         :omniauthable, omniauth_providers: %i(google_oauth2)

  def self.without_sns_data(auth)
    user = User.where(email: auth.info.email).first

      if user.present?
        sns = SnsCredential.create(
          uid: auth.uid,
          provider: auth.provider,
          user_id: user.id
        )
      else
        user = User.new(
          nickname: auth.info.name,
          email: auth.info.email,
        )
        sns = SnsCredential.new(
          uid: auth.uid,
          provider: auth.provider
        )
      end
      return { user: user ,sns: sns}
    end

  def self.with_sns_data(auth, snscredential)
    user = User.where(id: snscredential.user_id).first
    unless user.present?
      user = User.new(
        nickname: auth.info.name,
        email: auth.info.email,
      )
    end
    return {user: user}
  end

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    if snscredential.present?
      user = with_sns_data(auth, snscredential)[:user]
      sns = snscredential
    else
      user = without_sns_data(auth)[:user]
      sns = without_sns_data(auth)[:sns]
    end
    return { user: user ,sns: sns}
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
    user = comment.user
  end
end
