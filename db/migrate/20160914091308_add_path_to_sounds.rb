class AddPathToSounds < ActiveRecord::Migration
  def change
    add_column :sounds, :path, :string
  end
end
