class RemoveTimestampsFromReadings < ActiveRecord::Migration
  def change
    remove_column :readings, :created_at
    remove_column :readings, :updated_at
  end
end
