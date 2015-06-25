class AddMembershipsCountToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :memberships_count, :integer
  end
end
