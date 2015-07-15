class MoveProfileToUser < ActiveRecord::Migration
  def change
    drop_table :profiles

    add_column :users, :username, :string
    add_column :users, :time_zone, :string, default: "EST"
    add_column :users, :preferred_reading_hour, :integer, default: 12
  end
end
