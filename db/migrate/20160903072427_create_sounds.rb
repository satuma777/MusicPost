class CreateSounds < ActiveRecord::Migration
  def change
    create_table :sounds do |t|
      t.string :title
      t.text :content

      t.timestamps null: false
    end
  end
end
