class RenameNameColumnToPicture < ActiveRecord::Migration[6.0]
  def change
    rename_column :pictures, :name, :picture_name
  end
end
