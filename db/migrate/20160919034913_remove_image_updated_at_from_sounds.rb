class RemoveImageUpdatedAtFromSounds < ActiveRecord::Migration
  def change
    remove_column :sounds, :image_updated_at, :datetime
  end
end
