class AddBeginBookAndEndBookToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :begin_book, :string
    add_column :challenges, :end_book, :string
  end
end
