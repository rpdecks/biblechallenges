class AddDiscussionToReadings < ActiveRecord::Migration
  def change
    add_column :readings, :discussion, :text
  end
end
