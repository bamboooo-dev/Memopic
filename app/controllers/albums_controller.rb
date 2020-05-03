class AlbumsController < ApplicationController

  def index
    if user_signed_in?
      @albums = Album.all
      @album_form = AlbumForm.new
    end
  end

  def create
    @album_form = AlbumForm.new(album_params)
    if album = @album_form.save
      redirect_to album
    else
      redirect_to albums_path
    end
  end

  def show
    @album = Album.find(params[:id])
    @album_name = @album.name
    @pictures = @album.pictures
  end

  private

    def album_params
      params.require(:album_form).permit(:name, :picture_name)
    end
end
