
namespace :evan do
  desc "evans stuff"
  task drink: :environment do
    puts "yum these teas are good"
  end
  task eat: :environment do
    puts "yum these wings are good"
  end
end
