class CreateBookfrags < ActiveRecord::Migration
  def up
    create_table :bookfrags do |t|
      t.string :fragment
      t.integer :book_number 

      t.timestamps
    end
  end

  def down
    drop_table :bookfrags
  end
end
