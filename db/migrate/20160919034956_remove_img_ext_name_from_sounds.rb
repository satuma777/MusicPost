class RemoveImgExtNameFromSounds < ActiveRecord::Migration
  def change
    remove_column :sounds, :img_ext_name, :string
  end
end
