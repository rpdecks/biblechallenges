class ChangeDefaultBibleVersionOnMemberships < ActiveRecord::Migration
  def up
    change_column :memberships, :bible_version, :string, default: 'RCV'
  end

  def down
    change_column :memberships, :bible_version, :string, default: 'ESV'
  end
end
