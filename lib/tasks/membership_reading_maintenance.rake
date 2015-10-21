namespace :membership_reading do
  desc "update membership_reading attributes"

  task update: :environment do
    @mr_count = 0
    MembershipReading.all.each do |mr|
      membership_id = mr.membership_id
      if Membership.find_by_id(membership_id)
        membership = Membership.find(membership_id)
        user = membership.user
        MembershipReadingCompletion.new(user, membership, mr).attach_attributes
        @mr_count += 1
        print "."
      end
    end
    puts "#{@mr_count} membership readings udpated"
  end
end
