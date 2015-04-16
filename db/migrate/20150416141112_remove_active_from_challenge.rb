class RemoveActiveFromChallenge < ActiveRecord::Migration
  def change
    remove_column :challenges, :active, :boolean
  end
end
