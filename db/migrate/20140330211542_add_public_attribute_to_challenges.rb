class AddPublicAttributeToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :public, :boolean, default: false
  end
end
