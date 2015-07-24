class AddChaptersPerDateHashToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :chapters_per_date, :hstore, default: {}, null: false
  end
end
