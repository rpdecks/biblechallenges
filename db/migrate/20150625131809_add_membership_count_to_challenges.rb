class AddMembershipCountToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :memberships_count, :integer
  end
end
