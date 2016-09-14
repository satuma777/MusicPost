class AddExtNameToSounds < ActiveRecord::Migration
  def change
    add_column :sounds, :ext_name, :string
  end
end
