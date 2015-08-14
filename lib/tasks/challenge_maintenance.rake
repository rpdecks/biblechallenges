namespace :challenge do
  desc "challenge queries etc"

  task destroy_abandoned_challenges: :environment do
    Challenge.abandoned.each do |c|
      if (c.memberships.count == 0)
        c.destroy
        puts "Destroyed one :("
      end
    end
  end


  task find_wrong_memberships_count: :environment do
    Challenge.all.each do |c|
      actual_memberships = c.memberships.count

      if actual_memberships != c.memberships_count
        puts "#{c.name} says #{c.memberships_count} but is actually #{actual_memberships}"
      else
        puts "HOORAY #{c.name} says #{c.memberships_count} and is actually #{actual_memberships}"
      end
    end
  end
end
