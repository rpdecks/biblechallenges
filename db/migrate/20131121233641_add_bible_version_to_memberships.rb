class AddBibleVersionToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :bible_version, :string
  end
end
