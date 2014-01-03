class CopyValuesFromUserToProfile < ActiveRecord::Migration
  def up
    User.all.each do |u|
      u.create_profile(first_name: u.first_name, last_name: u.last_name, username: u.username)
    end

  end

  def down
    Profile.all.each do |p|
      p.user.first_name = p.first_name
      p.user.last_name = p.last_name
      p.user.username = p.username
      p.user.save
      p.destroy
    end

    
  end
end
