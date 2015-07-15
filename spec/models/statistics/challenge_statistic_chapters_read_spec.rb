require 'spec_helper'

describe ChallengeStatisticChaptersRead do

  describe "#calculate" do
    it "should calculate the total chapters read by all members of the challenge" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'John 1-10')
      membership1 = create(:membership, challenge: challenge)
      membership2 = create(:membership, challenge: challenge)
      membership3 = create(:membership, challenge: challenge)

      challenge.readings[0..4].each do |r|
        create(:membership_reading, membership: membership1, reading: r)
        create(:membership_reading, membership: membership2, reading: r)
        create(:membership_reading, membership: membership3, reading: r)
        end

      stat = ChallengeStatisticChaptersRead.new(challenge: challenge)

      expect(stat.calculate).to eq 15
    end
  end

    it "should sum all membership readings and return 0 when challenge has no membership readings" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'John 1-2')

      stat = ChallengeStatisticChaptersRead.new(challenge: challenge)

      expect(stat.calculate).to eq 0
    end
  end
