class CreateChallengeStatistics < ActiveRecord::Migration
  def change
    create_table :challenge_statistics do |t|
      t.string :type
      t.string :value

      t.timestamps null: false
    end
  end
end
