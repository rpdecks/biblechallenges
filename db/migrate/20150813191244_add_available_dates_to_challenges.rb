class AddAvailableDatesToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :available_dates, :date, array: true, default: []
  end
end
