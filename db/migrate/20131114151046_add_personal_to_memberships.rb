class AddPersonalToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :email, :string
    add_column :memberships, :username, :string
    add_column :memberships, :firstname, :string
    add_column :memberships, :lastname, :string
  end
end
