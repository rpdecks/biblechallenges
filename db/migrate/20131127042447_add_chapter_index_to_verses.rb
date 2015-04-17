class AddChapterIndexToVerses < ActiveRecord::Migration
  def change
    add_column :verses, :chapter_index, :integer
  end
end
