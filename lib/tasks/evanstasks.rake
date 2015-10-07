namespace :stale_challenges do
  desc "delete cahlleges that have had 0 members for the last 10 days"
  task prune: :environment do
    stale_challenges = Challenge.where('created_at <= ?', Time.now - 21.days)
    stale_challenges_with_no_updates = stale_challenges.where('updated_at <= ?', Time.now - 14.days)
    queue = []
    stale_challenges_with_no_updates.each do |sc|
      queue << sc unless sc.begindate >= Date.today
    end
    queue_size = queue.size
    puts "#{queue_size} Challenges will be destroyed. Continue? >> y/n: "
    respnse = STDIN.gets.chomp
    if respnse == "y"
      queue.each do |q|
        q.destroy
      end
      puts "#{queue_size} Challenges destroyed."
    else
      puts "Exiting..."
    end
  end
end
