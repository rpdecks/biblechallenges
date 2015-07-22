class AddDateRangesToSkipToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :date_ranges_to_skip, :text
  end
end
