class RemoveChallengeIdFromUserReadings < ActiveRecord::Migration
  def up
    remove_column :user_readings, :challenge_id
  end

  def down
    add_column :user_readings, :challenge_id, :integer
  end
end
