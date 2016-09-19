class RemoveImageFileNameFromSounds < ActiveRecord::Migration
  def change
    remove_column :sounds, :image_file_name, :string
  end
end
