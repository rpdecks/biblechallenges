# for seed data, look in the /db/seed folder and store your seed file(s) there

# loads all .rb files in the seed folder
unless Rails.env.production?
  Dir[File.dirname(__FILE__) + '/seed/*.rb'].each {|file| require file }
else
  puts "did you really try to seed production?"
end

