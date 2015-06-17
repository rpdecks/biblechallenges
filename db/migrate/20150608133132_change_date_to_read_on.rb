class ChangeDateToReadOn < ActiveRecord::Migration
  def change
    rename_column :readings, :date, :read_on
  end
end
