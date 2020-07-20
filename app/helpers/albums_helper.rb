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
      thumbpics << pictures[picture_index] if picture_index.present?
    end
    thumbpics
  end

  def collage(picture_paths)
    frames_dir = "#{Rails.root}/public/"
    big_frame_path = frames_dir + "big_frame.jpg"
    frame_path = frames_dir + "frame.png"
    collaged_image_path = "#{Rails.root}/tmp/images/collaged.jpg"

    frame = MiniMagick::Image.open(frame_path)
    result_image = MiniMagick::Image.open(big_frame_path)
    images = picture_paths.map do |picture_path|
      MiniMagick::Image.open(picture_path)
    end

    images.zip(["NorthWest", "NorthEast", "SouthWest", "SouthEast"].take(picture_paths.size)).each do |image, gravity|
      narrow = image[:width] > image[:height] ? image[:height] : image[:width]
      crop_size = narrow >= 600 ? 600 : narrow
      image.combine_options do |c|
        c.gravity "center"
        c.crop "#{crop_size}x#{crop_size}+0+0"
      end
      image.resize "290x290"
      framed_image = frame.composite(image) do |c|
        c.compose "src-in"
        c.geometry "+0+0"
      end
      result_image = result_image.composite(framed_image) do |c|
        c.compose "Over"
        c.gravity gravity
        c.geometry "+7+7"
      end
    end
    result_image.strip
    result_image.write collaged_image_path
    collaged_image_path
  end
end
