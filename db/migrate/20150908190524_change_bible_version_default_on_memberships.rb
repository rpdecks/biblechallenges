class ChangeBibleVersionDefaultOnMemberships < ActiveRecord::Migration
  def change
    change_column :memberships, :bible_version, :string, :default => "ESV"
  end
end
