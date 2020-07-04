module Api 
  module V1
    class FavoritesController < ApplicationController
      
      # POST /api/v1/favorites
      def create 
        @picture = Picture.find(params[:picture_id])
        current_user.join(@picture.album) unless current_user.joining?(@picture.album)
        current_user.favor(@picture)
      end
        
      # DELETE /api/v1/favorites/:id
      def destroy
        picture_id = Favorite.find(params[:id]).picture_id
        @picture = Picture.find(id: picture_id)
        current_user.unfavor(@picture)
      end
    end
  end
end