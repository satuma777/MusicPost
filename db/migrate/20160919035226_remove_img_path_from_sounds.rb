class RemoveImgPathFromSounds < ActiveRecord::Migration
  def change
    remove_column :sounds, :img_path, :string
  end
end
