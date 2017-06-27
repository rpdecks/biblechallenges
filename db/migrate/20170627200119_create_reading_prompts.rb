class CreateReadingPrompts < ActiveRecord::Migration
  def change
    create_table :reading_prompts do |t|
      t.references :reading, index: true, foreign_key: true
      t.text :content

      t.timestamps null: false
    end
  end
end
