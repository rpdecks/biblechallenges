require 'faker' if Rails.env.test?
# todo: update this in readme.md 
# run with: rake sample_fake:users[:count]

namespace :sample_fake do
  desc "generates fake users; augment: [count] number of users to generate (default: 10)"
  task data: :environment do
    Rails.env = 'development'  # this rake task should only be run in development
    users_count = 55
    DAYS_AGO = 15

    remove_current_records

    create_users(users_count)
    create_challenges
    generate_readings
    create_memberships
    create_groups
    add_members_to_groups
    mark_chapters_as_read
    generate_comments
    generate_comment_responses

    create_membership_stats
    create_challenge_stats
    create_group_stats
    create_user_stats

    puts ""
    puts ""
    puts ""
    puts "Log in with user1@test.com / password"


  end

  def generate_comments
    puts  "Generating Comments"
    Group.all.each do |g|
      g.members.each do |m|
        print'.'
        Comment.create(commentable_type: "Group", commentable_id: g.id, user: m, content: Faker::Lorem.paragraph)
      end
    end
  end

  def generate_comment_responses
    puts  "Generating Responses"
    Group.all.each do |g|
      g.comments.each do |c|
        print '.'
        Comment.create(commentable_type: "Comment", commentable_id: c.id, user: g.members.sample, content: Faker::Lorem.paragraph)
      end
    end

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
    # just add a random number of users between 5 and 50 to each challenge
    Challenge.all.each do |challenge|
      challenge.members.destroy_all
      challenge.members << User.all.sample(rand(25) + 25)
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
    # create five groups in each challenge
    puts "creating groups"
    Challenge.all.each do |challenge|
      group_names = fake_group_names.sample(5)
      group_names.each do |g|
        challenge.groups.create!(name: g, user: User.all.sample)
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
    Group.all.each do |group|
      group.destroy if group.members.empty?  # a possiblity
    end
  end

  def create_users(users_count)
    users_count.times do
      FactoryGirl.create(:user, image: random_person_image)
    end

    puts "Created #{User.count} users"
  end

  def create_challenges
    # first X users own the challenges
    Timecop.travel(- DAYS_AGO.days)
    challenge_names = fake_challenge_names
    User.limit(fake_challenge_names.size).each do |u|
      u.created_challenges << FactoryGirl.create(:challenge, name: challenge_names.pop, chapters_to_read: "Matt 1-28", owner: u)
    end
    Timecop.return
    puts "Created #{Challenge.count} challenges"
    puts "Created #{Reading.count} readings"
  end

  def random_person_image
    "http://api.randomuser.me/portraits/thumb/#{%w(men women).sample}/#{(1..96).to_a.sample}.jpg"
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

  def fake_challenge_names
    [
      "Entire New Testament",
      "John in 3 Weeks",
      "Just Exodus",
      "Paul's Epistles at UCLA",
      "Ga Tech: The Gospels",
      "OU NT Challenge",
      "USC Matthew Challenge",
      "Harvard: New Testament",
      "Irvine YP Challenge"
    ]

  end
  def fake_group_names
    [
      "Overcomers",
      "Hanging in there",
      "One Chapter Per Day",
      "Never Give Up!",
      "Pursue with Those",
      "Hallelujah Brothers",
      "Standing Strong",
      "Each Day, Each Morning",
    ]
  end
end
