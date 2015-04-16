class RemoveSubdomainFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :subdomain, :string
  end
end
