class AddExtraColumnsToMembershipReading < ActiveRecord::Migration
  def change
    add_column :membership_readings, :chapter_name, :string
    add_column :membership_readings, :chapter_id, :integer
    add_column :membership_readings, :challenge_name, :string
    add_column :membership_readings, :challenge_id, :integer
    add_column :membership_readings, :group_name, :string
    add_column :membership_readings, :group_id, :integer
    add_column :membership_readings, :user_id, :integer
    add_index :membership_readings, :user_id
    add_index :membership_readings, :chapter_id
    add_index :membership_readings, :challenge_id
    add_index :membership_readings, :group_id
  end
end
