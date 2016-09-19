class RemoveExtNameImageFromSounds < ActiveRecord::Migration
  def change
    remove_column :sounds, :ext_name_image, :string
  end
end
