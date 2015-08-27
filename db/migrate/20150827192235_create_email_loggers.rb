class CreateEmailLoggers < ActiveRecord::Migration
  def change
    create_table :email_loggers do |t|
      t.string :type
      t.integer :membership_id

      t.timestamps null: false
    end
  end
end
