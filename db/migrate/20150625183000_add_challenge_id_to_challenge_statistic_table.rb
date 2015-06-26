class AddChallengeIdToChallengeStatisticTable < ActiveRecord::Migration
  def change
    add_column :challenge_statistics, :challenge_id, :integer
  end
end
