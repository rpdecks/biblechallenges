class RenameChapterstoreadFromChallenge < ActiveRecord::Migration
  def change
  	rename_column :challenges, :chapterstoread, :chapters_to_read
  end
end
