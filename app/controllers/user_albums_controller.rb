class UserAlbumsController < ApplicationController
  before_action :authenticate_user!

  def create
    @album = Album.find(params[:album_id])
    current_user.join(@album)
    redirect_to @album
  end

end
