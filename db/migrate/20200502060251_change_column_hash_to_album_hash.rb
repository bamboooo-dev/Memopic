class ChangeColumnHashToAlbumHash < ActiveRecord::Migration[6.0]
  def change
    rename_column :albums, :hash, :album_hash
  end
end
