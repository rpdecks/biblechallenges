namespace :membership do
  desc "update membership_reading count"

  task update: :environment do
    Membership.find_each { |m| Membership.reset_counters(m.id, :membership_readings) }
  end
end
