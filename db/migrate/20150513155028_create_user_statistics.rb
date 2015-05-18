class CreateUserStatistics < ActiveRecord::Migration
  def change
    create_table :user_statistics do |t|
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :user_statistics, :user_id
  end
end
