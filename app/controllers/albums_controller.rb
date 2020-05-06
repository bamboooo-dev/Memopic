class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create]

  def index
    @albums = current_user.albums
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
    @album = Album.find(params[:id])
    @pictures = @album.pictures
  end

  private

    def album_params
      params.require(:album_form).permit(:name, {pictures: []})
    end
end
