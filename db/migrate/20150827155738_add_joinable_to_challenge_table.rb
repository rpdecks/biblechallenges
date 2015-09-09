class AddJoinableToChallengeTable < ActiveRecord::Migration
  def change
    add_column :challenges, :joinable, :boolean, default: true
  end
end
