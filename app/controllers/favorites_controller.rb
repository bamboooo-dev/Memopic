class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @picture = Picture.find(params[:picture_id])
    current_user.favor(@picture)
    redirect_to @picture.album
  end

  def destroy
    @picture = Picture.find(params[:id])
    current_user.unfavor(@picture)
    redirect_to @picture.album
  end
end
