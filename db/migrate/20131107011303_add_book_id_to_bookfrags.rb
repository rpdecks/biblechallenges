class AddBookIdToBookfrags < ActiveRecord::Migration
  def change
    add_column :bookfrags, :book_id, :integer
  end
end
