class AddChapterstoReadToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :chapterstoread, :string
  end
end
