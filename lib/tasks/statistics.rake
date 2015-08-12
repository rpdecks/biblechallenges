namespace :statistics do
  desc "handle statistical updates"

  task update_all: :environment do
    update_users
    update_memberships
    update_groups
    update_challenges
  end

  task update_groups: :environment do
    update_groups
  end

  def update_users
    User.all.each do |x| 
      x.update_stats
      print "u"
    end
    puts "Finished Users"
  end

  def update_memberships
    Membership.all.each do |x| 
      x.update_stats
      print "m"
    end
    puts "Finished Memberships"
  end

  def update_groups
    Group.all.each do |x| 
      x.update_stats
      print "g"
    end
    puts "Finished Groups"
  end

  def update_challenges
    Challenge.all.each do |x| 
      x.update_stats
      print "c"
    end
    puts "Finished Challenges"
  end
end


