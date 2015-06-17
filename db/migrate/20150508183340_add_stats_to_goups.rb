class AddStatsToGoups < ActiveRecord::Migration
  def change
    add_column :groups, :ave_sequential_reading_count, :integer, :default => 0
    add_column :groups, :ave_punctual_reading_percentage, :integer, :default => 0
    add_column :groups, :ave_progress_percentage, :integer, :default => 0
  end
end
