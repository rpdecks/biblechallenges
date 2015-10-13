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

  desc "delete challeges begun at least 3 weeks ago that have had 0 membership readings during the past 3 weeks, unless begindate is in the future"
  task prune_stale_challenges: :environment do
    stale_challenges = Challenge.underway_at_least_x_days(21).with_no_mr_for_the_past_three_weeks.uniq
    queue = []
    stale_challenges.each do |sc|
      queue << sc unless sc.begindate >= Date.today
    end

    queue.each do |q|
      q.destroy
      print "."
    end
  end
end
