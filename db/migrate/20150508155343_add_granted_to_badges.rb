class AddGrantedToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :granted, :boolean, default: false
  end
end
