module Api
  module V1
    class AlbumsController < ApplicationController

      include AlbumsHelper

      # GET /api/v1/albums
      def index
        @albums = current_user.albums
        thumpics = pick_thumbpic
        albums_with_thumpics = @albums.zip(thumpics)
        render json: albums_with_thumpics
      end

      # POST /api/v1/albums
      def create
        album = Album.new(name: params[:name], album_hash: SecureRandom.alphanumeric(20))
        params[:pictures].each do |picture|
          album.pictures.new(picture_name: picture)
        end
        album.save
        album.users << current_user
      end

      # GET /api/v1/albums/:album_hash
      def show
        album = Album.preload(:pictures).find_by!(album_hash: params[:album_hash])
        pictures =  album.pictures.left_joins(:favorites).group(:id).order('count(user_id) desc')
        picture_data = pictures.map do |picture|
          {
            "picture_id" => picture.id,
            "picture_url" => picture.picture_name.url,
            "favorite" => {
              "isFavored" => current_user.favoring?(picture),
              "favorite_id" => picture.favorites.find_by(user: current_user)&.id
            }
          }
        end
        picture_hash = {"album_name" => album.name, "pictures" => picture_data}
        render json: picture_hash
      end

      # PUT /api/v1/alubms/:album_hash/edit
      # def edit
      #   @album = Album.find_by(album_hash: params[:album_hash])
      #   @pictures = @album.pictures
      #   @album_form = AlbumForm.new(name: @album.name)
      # end

    end
  end
end
