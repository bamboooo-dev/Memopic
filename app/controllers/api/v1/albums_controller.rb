module Api
  module V1
    class AlbumsController < ApplicationController

      include AlbumsHelper

      # GET /api/v1/albums
      def index
        @albums = current_user.albums
        @thumpics = pick_thumbpic
        @albums_with_thumpics = @albums.zip(@thumpics)
      end

      # POST /api/v1/albums
      def create
        @album_form = AlbumForm.new(album_params)
        @album_form.save(current_user)
      end

      # GET /api/v1/albums/:album_hash
      def show
        @album = Album.find_by!(album_hash: params[:album_hash])
        @pictures =  @album.pictures.left_joins(:favorites).group(:id).order('count(user_id) desc')
        @top_pictures = @pictures.take(5)
        @bottom_pictures =
          if @pictures.length > 5
              @pictures[5..-1]
          else
              []
          end
      end

      # PUT /api/v1/alubms/:album_hash/edit
      # def edit
      #   @album = Album.find_by(album_hash: params[:album_hash])
      #   @pictures = @album.pictures
      #   @album_form = AlbumForm.new(name: @album.name)
      # end



      private

        def album_params
          params.require(:album_form).permit(:name, {pictures: []})
        end
    end
  end
end