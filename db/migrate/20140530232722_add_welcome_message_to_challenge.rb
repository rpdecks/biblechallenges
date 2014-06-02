class AddWelcomeMessageToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :welcome_message, :text
  end
end
