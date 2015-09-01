class RenameEmailLog < ActiveRecord::Migration
  def change
    rename_table :email_loggers, :email_logs
    rename_column :email_logs, :type, :event
  end
end
