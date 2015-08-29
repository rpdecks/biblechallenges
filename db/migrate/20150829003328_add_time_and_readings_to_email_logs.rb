class AddTimeAndReadingsToEmailLogs < ActiveRecord::Migration
  def change
    add_column :email_logs, :schedule_time, :datetime
    add_column :email_logs, :readings, :integer, array: true
  end
end
