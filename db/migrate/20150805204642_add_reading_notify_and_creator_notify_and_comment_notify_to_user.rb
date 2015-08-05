class AddReadingNotifyAndCreatorNotifyAndCommentNotifyToUser < ActiveRecord::Migration
  def change
    add_column :users, :reading_notify, :boolean, default: true
    add_column :users, :creator_notify, :boolean, default: true
    add_column :users, :comment_notify, :boolean, default: true
  end
end
