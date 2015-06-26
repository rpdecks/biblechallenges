class AddReadingsCountToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :readings_count, :integer
  end
end
