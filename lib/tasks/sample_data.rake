require 'faker' if Rails.env.test?
# todo: update this in readme.md 
# run with: rake sample_fake:users[:count]

namespace :sample_fake do
  desc "generates fake users; augment: [count] number of users to generate (default: 10)"
  task data: :environment do
    Rails.env = 'development'  # this rake task should only be run in development
    users_count = 25
    challenges_count = 10 

    remove_current_records

    create_users(users_count)
    create_challenges(challenges_count)
    generate_readings
    create_memberships
    create_groups
    add_members_to_groups
    mark_chapters_as_read
  end

  def mark_chapters_as_read
    # just randomly mark about half of them as read
    count = MembershipReading.count / 2
    MembershipReading.all.sample(count).each do |mr|
      mr.update_attribute(:state, "read")
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
      challenge.members << User.all.sample(rand(15) + 5)
    end
    puts " Created #{Membership.count} memberships"
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
    challenges_count.times do
      user = User.all.sample # warning: all.sample is very slow for large dbs.
                             #          only use this for seeding
      user.created_challenges << FactoryGirl.create(:challenge, owner: user)
    end
    puts "Created #{Challenge.count} challenges"
    puts "Created #{Reading.count} readings"
  end

  def remove_current_records
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
    puts "Deleting Badges"
    Badge.destroy_all

    puts "--Finished removing current records----------\n"
  end
end
