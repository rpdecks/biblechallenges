class AddMembershipIdToMembershipStatistics < ActiveRecord::Migration
  def change
    add_column :membership_statistics, :membership_id, :integer
    add_index :membership_statistics, :membership_id
  end
end
