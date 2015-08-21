class AddStatusToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :status, :string, default: "open"
  end
end
