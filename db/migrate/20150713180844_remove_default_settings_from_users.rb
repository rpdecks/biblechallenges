class RemoveDefaultSettingsFromUsers < ActiveRecord::Migration
  def change
    change_column_default(:users, :preferred_reading_hour, nil)
    change_column_default(:users, :time_zone, nil)
  end
end
