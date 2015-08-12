class ChangeColumnNameOnUserModel < ActiveRecord::Migration
  def change
    rename_column :users, :creator_notify, :message_notify
  end
end
