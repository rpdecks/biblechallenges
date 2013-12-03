class AddDefaultValueToBibleVerionOnMemberships < ActiveRecord::Migration
def up
  change_column :memberships, :bible_version, :string, default: 'ASV'
end

def down
  change_column :memberships, :bible_version, :string, default: nil
end
end
