class AddBookChaptersToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :book_chapters, :integer, array: true, default: []
  end
end
