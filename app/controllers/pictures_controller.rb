class PicturesController < ApplicationController
  def index
    @pictures = Picture.all
    @picture = Picture.new
  end
  def create
    @picture = Picture.create(picture_params)
    redirect_to pictures_index_path
  end

  private

    def picture_params
      params.require(:picture).permit(:name)
    end
end
