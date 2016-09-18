class AddImgExtNameToSounds < ActiveRecord::Migration
  def change
    add_column :sounds, :img_ext_name, :string
  end
end
