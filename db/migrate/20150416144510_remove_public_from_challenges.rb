class RemovePublicFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :public, :boolean
  end
end
