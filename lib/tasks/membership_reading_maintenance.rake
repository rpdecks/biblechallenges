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
    all_broken_duplicate_mr = MembershipReading.where(user_id: nil)
    membership_id_and_reading_id_array = all_broken_duplicate_mr.pluck(:membership_id, :reading_id).sort

    membership_id_and_reading_id_array.each do |mr|
      if MembershipReading.where(membership_id: mr[0], reading_id: mr[1]).size > 1
        MembershipReading.where(membership_id: mr[0], reading_id: mr[1]).first.destroy
      end
    end

    broken_membership_ids = MembershipReading.where(user_id: nil).pluck(:membership_id).uniq.sort
    broken_membership_ids.each do |m|
      if Membership.where(id: m).empty?
        MembershipReading.where(membership_id: m).destroy_all
      end
    end
  end
end

