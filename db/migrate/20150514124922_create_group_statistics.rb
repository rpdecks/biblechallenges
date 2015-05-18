class CreateGroupStatistics < ActiveRecord::Migration
  def change
    create_table :group_statistics do |t|
      t.integer :group_id
      t.string :value
      t.string :type
      t.timestamps null: false
    end
    add_index :group_statistics, :group_id
  end
end
