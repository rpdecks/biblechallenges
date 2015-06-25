require 'spec_helper'

describe GroupStatisticTotalChaptersRead do

  describe "#calculate" do
    it "calculates this accurately for all the members of a group" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-2')
      group = challenge.groups.create(name: "UC Irvine", user_id: User.first.id)
      memberships = create_list(:membership, 2, challenge: challenge)

      join_members_to_group(memberships, group)

      read_all_chapters(challenge)

      stat = GroupStatisticTotalChaptersRead.new(group: group)
      expect(stat.calculate).to eq 4  # 2 members, 2 chapters each
    end

  end


  def join_members_to_group(memberships, group)
    memberships.each do |m| 
      m.group = group
      m.save
    end
  end

  def read_all_chapters(challenge)
    challenge.readings.each do |r|
      challenge.memberships.each do |m|
        create(:membership_reading, reading: r, membership: m)
      end
    end
  end


end

