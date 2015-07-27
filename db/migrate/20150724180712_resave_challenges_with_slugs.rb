class ResaveChallengesWithSlugs < ActiveRecord::Migration
  def change
    Challenge.find_each(&:save)
  end
end
