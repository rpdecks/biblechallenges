class AddRecSequentialReadingCountToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :rec_sequential_reading_count, :integer
  end
end
