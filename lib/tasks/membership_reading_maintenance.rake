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

  task fixer: :environment do
    all_uniq_broken_mr = MembershipReading.where(user_id: nil).to_a.uniq { |mr| mr.reading_id }.sort

    all_uniq_broken_mr.each do |mr|
      membership = Membership.find(mr.membership_id)
      challenge = membership.challenge
    end
  end

end
