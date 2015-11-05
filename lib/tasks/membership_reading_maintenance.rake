namespace :membership_reading do
  desc "update membership_reading attributes"

  task update: :environment do
    @mr_count = 0
    MembershipReading.all.each do |mr|
      if mr.membership
        MembershipReadingCompletion.new(mr.membership.user, mr.membership, mr).attach_attributes
        @mr_count += 1
        print "."
      end
    end
    puts "#{@mr_count} membership readings udpated"
  end
end
