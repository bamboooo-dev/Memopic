class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @picture = Picture.find(params[:picture_id])
    current_user.join(@picture.album) unless current_user.joining?(@picture.album)
    current_user.favor(@picture)
    respond_to do |format|
      format.html { redirect_to @picture.album }
      format.js
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    current_user.unfavor(@picture)
    respond_to do |format|
      format.html { redirect_to @picture.album }
      format.js
    end
  end
end
