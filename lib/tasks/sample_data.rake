require 'faker'
# todo: update this in readme.md 
# run with: rake sample_fake:users[:count]

namespace :sample_fake do
  desc "generates fake users; augment: [count] number of users to generate (default: 10)"
  task data: :environment do
    Rails.env = 'development'  # this rake task should only be run in development
    users_count = 5
    challenges_count = 2
    memberships_count = 5

    remove_current_records

    create_users(users_count)
    create_challenges(challenges_count)
    create_memberships(memberships_count)
  end

  def create_memberships(memberships_count)
    puts "Creating memberships: "
    memberships_count.times do
      membership = FactoryGirl.build(:membership,
                                     user: user = User.all.sample,
                                     challenge: challenge = Challenge.all.sample)
      unless membership.save
        # possible duplicate of user-challenge pair
        if (membership.errors.full_messages.to_sentence ==
            "User has already been taken")
          puts " User (#{user.email}) has already been subscribed to challenge (#{challenge.name})"
        else # some other error (shouldn't happen)
          puts membership.errors.full_messages.to_sentence
        end
      end
    end

    puts " Created #{Membership.count} memberships"
    puts " Created #{MembershipReading.count} membership readings"
  end

  def create_users(users_count)
    users_count.times do
      User.create!(
        email: Faker::Internet.email,
        password: Faker::Internet.password(5)
      )
    end

    puts "Created #{User.count} users"
  end

  def create_challenges(challenges_count)
    challenges_count.times do
      user = User.all.sample # warning: all.sample is very slow for large dbs.
                             #          only use this for seeding
      user.created_challenges << FactoryGirl.create(:challenge)
    end
    puts "Created #{Challenge.count} challenges"
    puts "Created #{Reading.count} readings"
  end

  def remove_current_records
    puts "Deleting Users"
    User.delete_all
    puts "Deleting Challenges"
    Challenge.delete_all

    #todo: how come removing challenges doesn't remove readings?
    # is this by design?
    puts "Deleting Readings"
    Reading.delete_all
    puts "Deleting Memberships"
    Membership.delete_all

    #todo: how come removing membership doesn't remve membership readings?
    # is this by design?
    puts "Deleting Membership Readings"
    MembershipReading.delete_all

    puts "--Finished removing current records----------\n"
  end
end
