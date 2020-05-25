class AlbumsController < ApplicationController

  include AlbumsHelper

  before_action :authenticate_user!, only: [:index, :create, :edit, :destroy]
  before_action :confirm_sharer, only: [:edit, :destroy]

  def index
    @albums = current_user.albums
    @thumbpics = pick_thumbpic
    @album_form = AlbumForm.new
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
    @pictures =  @album.pictures.left_joins(:favorites).group(:id).order('count(user_id) desc')
    @top_pictures = @pictures.take(5)
    @bottom_pictures =
      if @pictures.length > 5
        @pictures[5..-1]
      else
        []
      end
  end

  def edit
    @album = Album.find_by(album_hash: params[:album_hash])
    @pictures = @album.pictures
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

  private

    def album_params
      params.require(:album_form).permit(:name, {pictures: []})
    end

    def confirm_sharer
      @album = Album.find_by(album_hash: params[:album_hash])
      redirect_to(albums_url) unless @album.users.include?(current_user)
    end
end
