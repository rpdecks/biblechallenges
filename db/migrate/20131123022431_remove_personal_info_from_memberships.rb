class RemovePersonalInfoFromMemberships < ActiveRecord::Migration
  def up
    remove_column :memberships, :username
    remove_column :memberships, :firstname
    remove_column :memberships, :lastname
    remove_column :memberships, :email
  end

  def down
    add_column :memberships, :username, :string
    add_column :memberships, :firstname, :string
    add_column :memberships, :lastname, :string
    add_column :memberships, :email, :string
  end
end
