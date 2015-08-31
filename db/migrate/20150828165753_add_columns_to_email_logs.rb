class AddColumnsToEmailLogs < ActiveRecord::Migration
  def change
    add_column :email_logs, :challenge_id, :integer
    add_column :email_logs, :user_id, :integer
    add_column :email_logs, :email, :string
    add_column :email_logs, :time_zone, :string
    add_column :email_logs, :preferred_reading_hour, :integer
  end
end
