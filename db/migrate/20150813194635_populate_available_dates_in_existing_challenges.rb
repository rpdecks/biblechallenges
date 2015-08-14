class PopulateAvailableDatesInExistingChallenges < ActiveRecord::Migration
  def change
    Challenge.all.each do |c|
      if c.available_dates.empty?
        c.available_dates = AvailableDatesCalculator.new(c).available_dates
        c.save
      end
    end
  end
end
