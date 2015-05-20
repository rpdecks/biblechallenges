class AddValueToMembershipStatistics < ActiveRecord::Migration
  def change
    add_column :membership_statistics, :value, :string
  end
end
