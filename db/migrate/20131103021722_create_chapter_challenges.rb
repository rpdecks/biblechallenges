class CreateChapterChallenges < ActiveRecord::Migration
  def change
    create_table :chapter_challenges do |t|
      t.references :challenge
      t.references :chapter 

      t.timestamps
    end
  end
end
