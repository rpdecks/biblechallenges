class ConvertValueToInteger < ActiveRecord::Migration
  def change
    change_column :challenge_statistics, :value, 'integer USING CAST(value AS integer)'
    change_column :group_statistics, :value, 'integer USING CAST(value AS integer)'
    change_column :membership_statistics, :value, 'integer USING CAST(value AS integer)'
    change_column :user_statistics, :value, 'integer USING CAST(value AS integer)'
  end
end
