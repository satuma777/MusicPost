class AddImageForPaperclipToUser < ActiveRecord::Migration
  def change
    add_attachment :sounds, :image
  end
end
