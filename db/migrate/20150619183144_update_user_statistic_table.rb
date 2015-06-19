class UpdateUserStatisticTable < ActiveRecord::Migration
  def change
    add_column :user_statistics, :type, :string
    add_column :user_statistics, :value, :string
  end
end
