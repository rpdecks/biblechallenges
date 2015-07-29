class MakeValuesDefaultToZero < ActiveRecord::Migration
  def change
    change_column_default :challenge_statistics, :value, 0
    change_column_default :group_statistics, :value, 0
    change_column_default :membership_statistics, :value, 0
    change_column_default :user_statistics, :value, 0
  end
end
