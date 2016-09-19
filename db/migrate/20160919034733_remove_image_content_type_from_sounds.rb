class RemoveImageContentTypeFromSounds < ActiveRecord::Migration
  def change
    remove_column :sounds, :image_content_type, :string
  end
end
