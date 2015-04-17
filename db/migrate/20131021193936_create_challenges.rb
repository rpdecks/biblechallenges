class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :owner_id
      t.string :subdomain
      t.string :name
      t.date :begindate
      t.date :enddate

      t.timestamps
    end
  end
end
