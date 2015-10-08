class AddMembershipReadingCountToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :membership_readings_count, :integer, default: 0
  end
end
