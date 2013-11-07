class RemoveBookNumberFromChapters < ActiveRecord::Migration
  def up
    remove_column :chapters, :book_number
  end

  def down
    add_column :chapters, :book_number, :integer
  end
end
