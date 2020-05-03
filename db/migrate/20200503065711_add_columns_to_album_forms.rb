class AddColumnsToAlbumForms < ActiveRecord::Migration[6.0]
  def change
    add_column :album_forms, :name, :string
    add_column :album_forms, :album_hash, :string
    add_column :album_forms, :picture_name, :string
  end
end
