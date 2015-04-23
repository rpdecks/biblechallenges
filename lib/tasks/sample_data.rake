require 'faker'
# todo: update this in readme.md 
# run with: rake sample_fake:users[:count]

namespace :sample_fake do
  desc "generates fake users; augment: [count] number of users to generate (default: 10)"
  task data: :environment do
    Rails.env = 'development'  # this rake task should only be run in development
    users_count = 5
    challenges_count = 2

    remove_current_records

    create_users(users_count)
    create_challenges(challenges_count)
  end

  def create_users(users_count)
    users_count.times do
      User.create!(
        email: Faker::Internet.email,
        password: Faker::Internet.password(5)
      )
    end

    print "Created #{User.count} users \n"
  end

  def create_challenges(challenges_count)
    challenges_count.times do
      user = User.all.sample # warning: all.sample is very slow for large dbs.
                             #          only use this for seeding
      user.created_challenges << FactoryGirl.create(:challenge)
    end
    print "Created #{Challenge.count} challenges \n"
  end

  def remove_current_records
    puts "Deleting Users"
    User.delete_all
    puts "Deleting Challenges"
    Challenge.delete_all

    print "--Finished removing current records----------\n\n"
  end
end
