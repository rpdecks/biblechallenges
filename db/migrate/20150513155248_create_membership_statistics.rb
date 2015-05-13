class CreateMembershipStatistics < ActiveRecord::Migration
  def change
    create_table :membership_statistics do |t|
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :membership_statistics, :user_id
  end
end
