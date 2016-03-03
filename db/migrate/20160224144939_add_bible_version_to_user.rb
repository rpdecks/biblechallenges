class AddBibleVersionToUser < ActiveRecord::Migration
  def change
    add_column :users, :bible_version, :string, default: "RCV"
  end
end
