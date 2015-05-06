class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :challenge_id, index: true
      t.string :name
      t.integer :user_id, index: true

      t.timestamps null: false
    end
  end
end
