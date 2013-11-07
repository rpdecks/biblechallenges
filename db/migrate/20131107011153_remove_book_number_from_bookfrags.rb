class RemoveBookNumberFromBookfrags < ActiveRecord::Migration
  def up
    remove_column :bookfrags, :book_number
  end

  def down
    add_column :bookfrags, :book_number, :integer
  end
end
