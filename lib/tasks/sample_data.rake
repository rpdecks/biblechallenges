require 'faker'
# todo: update this in readme.md 
# run with: rake sample_fake:users[:count]

namespace :sample_fake do
  desc "generates fake users; augment: [count] number of users to generate (default: 10)"
  task users: :environment do
    Rails.env = 'development'  # this rake task should only be run in development
    users_count = 5

    remove_current_records

    create_users(users_count)
  end

  def create_users(users_count)
    users_count.times do
      User.create!(
        email: Faker::Internet.email,
        password: Faker::Internet.password(5)
      )
    end

    print "\n\n"
    print "Created #{User.count} users \n"
  end

  def remove_current_records
    puts "Deleting Users"
    User.delete_all
  end
end
