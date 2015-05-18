class AddTypeToMembershipStatistics < ActiveRecord::Migration
  def change
    add_column :membership_statistics, :type, :string
  end
end
