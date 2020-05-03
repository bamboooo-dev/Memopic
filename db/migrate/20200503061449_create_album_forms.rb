class CreateAlbumForms < ActiveRecord::Migration[6.0]
  def change
    create_table :album_forms do |t|

      t.timestamps
    end
  end
end
