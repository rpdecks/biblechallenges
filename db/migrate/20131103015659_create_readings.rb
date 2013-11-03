class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings do |t|
      t.references :chapter
      t.references :challenge
      t.date       :date

      t.timestamps
    end
  end
end
