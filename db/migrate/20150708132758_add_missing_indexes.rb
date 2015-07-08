class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :memberships, [:group_id, :user_id]
    add_index :memberships, :user_id
    add_index :memberships, :challenge_id
    add_index :memberships, :group_id
    add_index :memberships, [:challenge_id, :user_id]
    add_index :membership_readings, :membership_id
    add_index :membership_readings, :reading_id
    add_index :membership_readings, [:membership_id, :reading_id]
    add_index :challenge_statistics, :challenge_id
    add_index :challenge_statistics, [:id, :type]
    add_index :group_statistics, [:id, :type]
    add_index :membership_statistics, [:id, :type]
    add_index :user_statistics, [:id, :type]
    add_index :verses, :chapter_index
    add_index :challenges, :owner_id
    add_index :badges, [:id, :type]
    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :readings, :challenge_id
    add_index :readings, :chapter_id
    add_index :chapter_challenges, :chapter_id
    add_index :chapter_challenges, :challenge_id
  end
end
