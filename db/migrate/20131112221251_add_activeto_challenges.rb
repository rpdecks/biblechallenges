class AddActivetoChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :active, :boolean, default: false
  end
end
