class RemoveStateFromMembershipReadings < ActiveRecord::Migration
  def change
    remove_column :membership_readings, :state, :string
  end
end
