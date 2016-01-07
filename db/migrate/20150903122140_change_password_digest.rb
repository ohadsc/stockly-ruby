class ChangePasswordDigest < ActiveRecord::Migration
  def change
    rename_column :users, :password_digest, :password_legacy
  end
end
