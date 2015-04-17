class AddDefaultToStateOnMembershipReadings < ActiveRecord::Migration
  def up
    change_column :membership_readings, :state, :string, default: 'unread'
  end

  def down
    change_column :membership_readings, :state, :string, default: nil
  end
end
