class AddReadingHourToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :preferred_reading_hour, :integer, default: 0
  end
end
