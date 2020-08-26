class AddLatLngTakenAtToPictures < ActiveRecord::Migration[6.0]
  def change
    add_column :pictures, :latitude, :float
    add_column :pictures, :longitude, :float
    add_column :pictures, :taken_at, :datetime
  end
end
