class AlbumsController < ApplicationController
  def index
    @albums = Album.all
    @album_form = AlbumForm.new
  end
  def create
  @album_form = AlbumForm.new(album_params)
    if @album_form.save
      redirect_to('/pictures/index')
    else
      redirect_to pictures_index_path
    end
  end

  private

    def album_params
      params.require(:album_form).permit(:name, :album_hash, :picture_name)
    end
end
