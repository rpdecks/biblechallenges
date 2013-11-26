class DropUserReadingsTable < ActiveRecord::Migration
def up
    drop_table :user_readings
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
