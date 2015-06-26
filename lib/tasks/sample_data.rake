require 'faker' if Rails.env.test?
# todo: update this in readme.md 
# run with: rake sample_fake:users[:count]

namespace :sample_fake do
  desc "generates fake users; augment: [count] number of users to generate (default: 10)"
  task data: :environment do
    Rails.env = 'development'  # this rake task should only be run in development
    users_count = 25
    challenges_count = 3  #used to be 10 but takes a while
    DAYS_AGO = 15

    remove_current_records

    create_users(users_count)
    create_challenges(challenges_count)
    generate_readings
    create_memberships
    create_groups
    add_members_to_groups
    mark_chapters_as_read

    create_membership_stats
    create_challenge_stats
    create_group_stats
    create_user_stats

    puts ""
    puts ""
    puts ""
    puts "Log in with user1@test.com / password"


  end

  def mark_chapters_as_read
    # just randomly mark about half of them as read
    Membership.all.each do |m|
    Timecop.travel(-15.days)
      m.readings.limit(DAYS_AGO).each do |r|
        MembershipReading.create(membership_id: m.id, reading_id: r.id) if rand(2) == 1
        Timecop.travel(1.day)
      end
    Timecop.return
    end
  end

  def generate_readings
    puts "Generating Readings for each challenge:"
    Challenge.all.each do |c|
      print '.'
      c.generate_readings
    end
  end

  def create_memberships
    puts "Creating memberships: "
    # just add a random number of users between 5 and 20 to each challenge
    Challenge.all.each do |challenge|
      challenge.members.destroy_all
      challenge.members << User.all.sample(rand(15) + 5)
    end
    puts " Created #{Membership.count} memberships"
  end

  def create_group_stats
    puts "creating group statistics:"
    Group.all.each do |g|
      g.associate_statistics
      g.update_stats
      print "."
    end
  end

  def create_user_stats
    puts "creating user statistics:"
    User.all.each do |u|
      u.associate_statistics
      u.update_stats
      print "."
    end
  end

  def create_challenge_stats
    puts "creating challenge statistics:"
    Challenge.all.each do |u|
      u.associate_statistics
      u.update_stats
      print "."
    end
  end

  def create_membership_stats
    puts "creating membership statistics:"
    Membership.all.each do |m|
      m.associate_statistics
      m.update_stats
      print "."
    end
  end

  def create_groups
    # create three groups in each challenge
    puts "creating groups"
    Challenge.all.each do |challenge|
      3.times do
        challenge.groups.create!(name: "#{Faker::Name.name}'s Group", user: User.all.sample)
        print "."
      end
    end
  end

  def add_members_to_groups
    #every member of every challenge in a group
    puts "adding members to groups"
    Challenge.all.each do |challenge|
      challenge.memberships.each do |membership|
        membership.group = challenge.groups.sample
        membership.save
        print "."
      end
    end
  end

  def create_users(users_count)
    users_count.times do
      FactoryGirl.create(:user)
    end

    puts "Created #{User.count} users"
  end

  def create_challenges(challenges_count)
    # first X users own the challenges
    Timecop.travel(- DAYS_AGO.days)
    User.limit(challenges_count).each do |u|
      u.created_challenges << FactoryGirl.create(:challenge, chapters_to_read: "Matt 1-28", owner: u)
    end
    Timecop.return
    puts "Created #{Challenge.count} challenges"
    puts "Created #{Reading.count} readings"
  end

  def remove_current_records
    MembershipStatistic.destroy_all
    puts "Deleting Users"
    User.destroy_all
    puts "Deleting Challenges"
    Challenge.destroy_all

    #todo: how come removing challenges doesn't remove readings?
    # is this by design?
    puts "Deleting Readings"
    Reading.destroy_all
    puts "Deleting Memberships"
    Membership.destroy_all
    puts "Deleting Groups"
    Group.destroy_all

    #todo: how come removing membership doesn't remve membership readings?
    # is this by design?
    puts "Deleting Membership Readings"
    MembershipReading.destroy_all
    puts "Deleting Statistics"
    MembershipStatistic.destroy_all
    GroupStatistic.destroy_all
    UserStatistic.destroy_all
    ChallengeStatistic.destroy_all
    puts "Deleting Badges"
    Badge.destroy_all

    puts "--Finished removing current records----------\n"
  end
end
