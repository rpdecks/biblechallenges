require 'spec_helper'

describe MembershipGenerator do
  describe '#generate' do
    it 'Should create memberships if challenge and new_members are passed in' do
      fake_members = [double(:member1), double(:member2)]
      challenge = double(:challenge, members: [])
      allow(Membership).to receive(:create)
      allow(MembershipCompletion).to receive(:new)

      MembershipGenerator.new(challenge, fake_members).generate

      expect(Membership).to have_received(:create).exactly(2).times
      expect(MembershipCompletion).to have_received(:new).exactly(2).times
    end
  end


  describe '#new_members_not_in_this_challenge' do
    it "Should only create membership for new members if existing members are passed in" do
      existing_member = double(:existing_member)
      new_member = double(:new_member)
      challenge = double(:challenge, members: [existing_member])
      service = MembershipGenerator.new(challenge, [new_member, existing_member])

      expect(service.new_members_not_in_this_challenge).to eq [new_member]
    end
  end
end
