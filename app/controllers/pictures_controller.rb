class PicturesController < ApplicationController
  def index
    @pictures = Picture.all
  end
  # def create
  #   album = Album.new(
  #     picture_name: 'test',
  #     album_hash: 'test_hash'
  #   )
  #   album.save
  #   @picture = album.pictures.build(picture_params)
  #   if @picture.save
  #   redirect_to pictures_index_path
  #   else
  #   redirect_to albums_index_path
  #   end
  # end

  private

    def picture_params
      params.require(:picture).permit(:picture_name)
    end
end
