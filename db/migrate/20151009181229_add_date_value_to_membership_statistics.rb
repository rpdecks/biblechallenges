class AddDateValueToMembershipStatistics < ActiveRecord::Migration
  def change
    add_column :membership_statistics, :date_value, :datetime, index: true
  end
end
