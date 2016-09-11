class AddUpfileToSounds < ActiveRecord::Migration
  def change
    add_column :sounds, :upfile, :binary
  end
end
