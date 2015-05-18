class AddStatsToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :rec_sequential_reading_count, :integer, :default => 0
    add_column :memberships, :punctual_reading_percentage, :integer, :default => 0
    add_column :memberships, :progress_percentage, :integer, :default => 0
  end
end
