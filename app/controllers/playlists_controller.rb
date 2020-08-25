class PlaylistsController < ApplicationController
  def create
    album = Album.find(params[:album_id])
    @playlist = Playlist.new(playlist_params)
    @playlist.album_id = album.id
    @playlist.save!
    redirect_to album
  end

  def destroy
  end

  private

    def playlist_params
      params.require(:playlist).permit(:name, :url)
    end
end
