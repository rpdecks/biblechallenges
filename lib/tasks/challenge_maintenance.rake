namespace :challenge do
  desc "challenge queries etc"

  task destroy_abandoned_challenges: :environment do
    abandoned_challenges = Challenge.underway_at_least_x_days(5).abandoned
    abandoned_challenges.each do |acs|
      if (acs.memberships.count == 0)
        acs.destroy unless acs.begindate >= Date.today
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

  desc "delete challeges older than 3 weeks with either 0 members or no membership readings unless the challenge begindate is in the future"


  task prune_stale_challenges: :environment do
    last_3_weeks_of_challenges = Challenge.underway_at_least_x_days(21)
    abandoned_queue = last_3_weeks_of_challenges.abandoned

    stale_challenge_ids = last_3_weeks_of_challenges.with_no_mr_for_the_past_x_days(21).pluck(:id).uniq # pluck id puts AR-relation to an array
    stale_queue = []
    stale_challenge_ids.each do |id|
      challenge = Challenge.find(id)
      stale_queue << challenge 
    end

    abandoned_and_stale_challenges = stale_queue | abandoned_queue

    puts "Destroying stale & abandoned challenges"
    abandoned_and_stale_challenges.each do |c|
      c.destroy unless c.begindate >= Date.today
      print "."
    end
  end
end
