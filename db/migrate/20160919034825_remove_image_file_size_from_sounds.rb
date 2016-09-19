class RemoveImageFileSizeFromSounds < ActiveRecord::Migration
  def change
    remove_column :sounds, :image_file_size, :integer
  end
end
