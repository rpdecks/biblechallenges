class RemoveProfileFieldsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :username
  end

  def down
    add_column :users, :username, :string
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
  end
end
