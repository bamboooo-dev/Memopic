class RenamePictureNameColumnToAlbumForms < ActiveRecord::Migration[6.0]
  def change
    rename_column :album_forms, :picture_name, :pictures
  end
end
