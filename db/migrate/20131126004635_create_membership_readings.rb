class CreateMembershipReadings < ActiveRecord::Migration
  def change
    create_table :membership_readings do |t|
      t.references :membership
      t.references :reading
      t.string     :state
      t.timestamps
    end
  end
end
