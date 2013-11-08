class CreateVerses < ActiveRecord::Migration
  def change
    create_table :verses do |t|
      t.string :version
      t.string :book_name
      t.integer :chapter_number
      t.integer :verse_number
      t.text :versetext
      t.integer :book_id

      t.timestamps
    end
  end
end
