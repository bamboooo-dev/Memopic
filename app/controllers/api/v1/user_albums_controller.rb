module Api
  module V1
    class UserAlbumsController < ApplicationController

      # POST api/v1/user_albums
      def create
        album = Album.find(params[:album_id])
        current_user.join(album)
      end
    end
  end
end