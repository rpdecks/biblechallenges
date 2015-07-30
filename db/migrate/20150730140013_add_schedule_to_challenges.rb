class AddScheduleToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :schedule, :json, default: {}, null: false
  end
end
