class AddDatesToSkipToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :dates_to_skip, :string
  end
end
