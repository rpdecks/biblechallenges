require 'spec_helper'

describe MembershipGenerator do

  it "Should create a membership in the passed in challenge for all new_members passed in" do
    fake_members = [double(:member1), double(:member2)]
    challenge = double(:challenge, members: [])
    allow(Membership).to receive(:create)
    allow(MembershipCompletion).to receive(:new)

    MembershipGenerator.new(challenge, fake_members).generate

    expect(Membership).to have_received(:create).exactly(2).times
    expect(MembershipCompletion).to have_received(:new).exactly(2).times
  end


  it "Should create a membership in the passed in challenge for all new_members passed in" do
    challenge_member = double
    challenge = double(:challenge, members: [challenge_member])
    allow(Membership).to receive(:create)
    allow(MembershipCompletion).to receive(:new)

    MembershipGenerator.new(challenge, [challenge_member, double]).generate

    expect(Membership).to have_received(:create).exactly(1).times
    expect(MembershipCompletion).to have_received(:new).exactly(1).times
  end
end
