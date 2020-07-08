module Api 
  module V1
    class FavoritesController < ApplicationController
      
      # POST /api/v1/favorites
      def create 
        @picture = Picture.find(picture_params['picture_id'])
        current_user.join(@picture.album) unless current_user.joining?(@picture.album)
        current_user.favor(@picture)
        favorite_id = @picture.favorites.find_by(user: current_user).id
        render json: favorite_id
      end
        
      # DELETE /api/v1/favorites/:id
      def destroy
        Favorite.find(params[:id]).destroy!
      end

      private
      def picture_params
        params.require(:favorite).permit(:picture_id)
      end

    end
  end
end