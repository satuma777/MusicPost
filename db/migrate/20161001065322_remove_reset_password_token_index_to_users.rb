class RemoveResetPasswordTokenIndexToUsers < ActiveRecord::Migration
  def change
    remove_index :users, :reset_password_token
  end
end
