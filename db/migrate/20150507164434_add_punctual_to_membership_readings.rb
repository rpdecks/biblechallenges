class AddPunctualToMembershipReadings < ActiveRecord::Migration
  def change
    add_column :membership_readings, :punctual, :integer
  end
end
