# put necessary ENV keys in here so there is a notification for tests / dev
%w(APP_URL).each do |i|
  puts "WARNING: missing ENV['#{i}']" if ENV[i].blank?
end
