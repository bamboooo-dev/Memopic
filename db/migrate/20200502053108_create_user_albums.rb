class CreateUserAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :user_albums do |t|
      t.integer :user_id
      t.integer :album_id

      t.timestamps
    end
    add_index :user_albums, :user_id
    add_index :user_albums, :album_id
    add_index :user_albums, [:user_id, :album_id], unique: true
  end
end
