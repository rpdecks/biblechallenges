class AddGroupIdToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :group_id, :integer, index: true
  end
end
