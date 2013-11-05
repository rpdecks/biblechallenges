class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string  :book_name
      t.integer :book_number
      t.integer :chapter_number
      t.integer :chapter_index

      t.timestamps
    end
  end
end
