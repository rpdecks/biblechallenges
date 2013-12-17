class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user
      t.integer :commentable_id
      t.string :commentable_type
      t.boolean :invisible, default: false
      t.integer :flag_count, null:false, default: 0

      t.timestamps
    end
  end
end
