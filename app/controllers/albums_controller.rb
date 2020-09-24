require 'aws-sdk-s3'

class AlbumsController < ApplicationController

  include AlbumsHelper

  before_action :authenticate_user!, only: [:index, :create, :edit, :destroy]
  before_action :confirm_sharer, only: [:edit, :destroy]

  require 'rspotify'
  OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers]=OpenSSL::SSL::SSLContext.new.ciphers;
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def index
    @albums = current_user.albums
    @thumbpics = pick_thumbpic
    @album_form = AlbumForm.new
    @playlists =
      if current_user.provider == "spotify"
        RSpotify::User.find(current_user.uid).playlists.map { |spotify_playlist|
          {
            image_url: spotify_playlist.images[2]["url"],
            name: spotify_playlist.name,
            url: spotify_playlist.external_urls["spotify"],
          }
        }
      else
        []
      end
    gon.thumbpics_data = @albums.zip(@thumbpics).map do |album, thumbpic|
      { album_name: album.name,
        album_hash: album.album_hash,
        playlists: album.playlists,
        thumbpic_url: thumbpic.picture_name.url,
        lat: thumbpic.latitude,
        lng: thumbpic.longitude,
      }
    end
  end

  def create
    @album_form = AlbumForm.new(album_params)
    if album = @album_form.save(current_user)
      redirect_to album
    else
      redirect_to albums_path
    end
  end

  def show
    @album = Album.find_by!(album_hash: params[:album_hash])
    @pictures =  @album.pictures.left_joins(:favorites).group(:id).order('count(user_id) desc').order(created_at: :desc)
    @top_pictures = @pictures.take(5)
    @bottom_pictures =
      if @pictures.length > 5
        @pictures[5..-1]
      else
        []
      end
    @playlist = Playlist.new
    @playlists = @album.playlists
  end

  def edit
    @album = Album.find_by(album_hash: params[:album_hash])
    @pictures = @album.pictures.left_joins(:favorites).group(:id).order('count(user_id) desc').order(created_at: :desc)
    @album_form = AlbumForm.new(name: @album.name)
  end

  def update
    album = Album.find_by(album_hash: params[:album_hash])
    @album_form = AlbumForm.new(album_params)
    if @album_form.update(album)
      redirect_to album
    else
      redirect_to edit_album_path(album)
    end
  end

  def destroy
    Album.find_by(album_hash: params[:album_hash]).destroy
    redirect_to albums_url
  end

  def export
    s3 = Aws::S3::Resource.new(
      access_key_id: ENV["AWS_S3_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_S3_SECRET_ACCESS_KEY"],
      region: ENV["AWS_REGION"]
    )
    @album = Album.find_by(album_hash: params[:album_hash])
    pictures = @album.pictures.left_joins(:favorites).group(:id).order('count(user_id) desc').take(4)
    picture_paths = []
    pictures.each do |picture|
      picture_path = "#{Rails.root}/tmp/images/#{picture.picture_name.identifier}"
      if !File.exist?(picture_path)
        s3.bucket(ENV["AWS_S3_BUCKET"]).object(picture.picture_name.current_path).get(response_target: picture_path)
      end
      picture_paths.push picture_path
    end
    collaged_image_path = collage(picture_paths)
    send_file collaged_image_path
  end

  private

    def album_params
      params.require(:album_form).permit(:name, {pictures: []}, :playlist_name, :playlist_url)
    end

    def confirm_sharer
      @album = Album.find_by(album_hash: params[:album_hash])
      redirect_to(albums_url) unless @album.users.include?(current_user)
    end
end
