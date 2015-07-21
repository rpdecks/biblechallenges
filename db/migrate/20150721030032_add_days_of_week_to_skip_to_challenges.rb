class AddDaysOfWeekToSkipToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :days_of_week_to_skip, :text, array: true, default: []
  end
end
