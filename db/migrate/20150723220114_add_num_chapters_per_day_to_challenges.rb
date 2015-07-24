class AddNumChaptersPerDayToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :num_chapters_per_day, :integer, default: 1
  end
end
