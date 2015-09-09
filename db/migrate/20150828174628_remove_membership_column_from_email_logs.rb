class RemoveMembershipColumnFromEmailLogs < ActiveRecord::Migration
  def change
    remove_column :email_logs, :membership_id, :integer
  end
end
