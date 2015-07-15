class ChangePunctualToOnSchedule < ActiveRecord::Migration
  def change
    rename_column :membership_readings, :punctual, :on_schedule
  end
end
