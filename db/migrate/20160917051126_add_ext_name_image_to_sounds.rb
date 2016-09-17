class AddExtNameImageToSounds < ActiveRecord::Migration
  def change
    add_column :sounds, :ext_name_image, :string
  end
end
