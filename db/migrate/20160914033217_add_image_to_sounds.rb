class AddImageToSounds < ActiveRecord::Migration
  def change
    add_column :sounds, :image, :string
  end
end
