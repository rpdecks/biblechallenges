class ChangeDaysOfWeekToSkip < ActiveRecord::Migration
  def change
    remove_column :challenges, :days_of_week_to_skip
    add_column :challenges, :days_of_week_to_skip, :integer, array: true, default: []
  end
end
