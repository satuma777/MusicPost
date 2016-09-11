class RemoveSoundFromSounds < ActiveRecord::Migration
  def change
    remove_column :sounds, :sound, :string
  end
end
