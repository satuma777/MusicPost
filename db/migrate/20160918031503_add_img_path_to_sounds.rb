class AddImgPathToSounds < ActiveRecord::Migration
  def change
    add_column :sounds, :img_path, :string
  end
end
