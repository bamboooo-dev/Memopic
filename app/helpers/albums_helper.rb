module AlbumsHelper
  def pick_thumbpic
    thumbpics = []
    @albums.each do |album|
      favorite_counts = []
      pictures = album.pictures
      pictures.each do |picture|
        favorite_counts << picture.favoriters.count
      end
      picture_index = favorite_counts.index(favorite_counts.max)
      thumbpics << pictures[picture_index]
    end
    thumbpics
  end
end
