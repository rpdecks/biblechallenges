class CreateUserReadings < ActiveRecord::Migration
  def change
    create_table :user_readings do |t|
      t.references :user
      t.references :reading
      t.references :challenge

      t.timestamps
    end
  end
end
