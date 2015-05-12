class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.references :user, index: true, foreign_key: true
      t.string :type

      t.timestamps null: false
    end
  end
end
