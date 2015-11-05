require 'spec_helper'

describe MembershipReadingCompletion do
  scenario "attach_attributes" do
    user = create(:user)
    challenge = create(:challenge_with_readings, owner_id: user.id)
    membership = challenge.join_new_member(user)
    reading = challenge.readings.first
    membership_reading = create(:membership_reading, membership_id: membership.id, reading_id: reading.id)
    MembershipReadingCompletion.new(user, membership, membership_reading).attach_attributes
    expect(membership_reading.user_id).to eq user.id
  end
end
