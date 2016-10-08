class AddSoundIdToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :sound_id, :integer
  end
end
