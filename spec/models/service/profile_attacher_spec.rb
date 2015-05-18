require 'spec_helper'

describe ProfileAttacher do

  describe "#attach_profile" do

    it "should attach a Profile to a user" do
      user = create(:user)

      ProfileAttacher.attach_profile(user)

      expect(user.profile).to_not be_nil
    end

    it "should not attach a Profile to a user with one already" do
      user = double "user"
      allow(user).to receive(:profile).and_return true
      allow(user).to receive(:create_profile)

      ProfileAttacher.attach_profile(user)

      expect(user).not_to have_received(:create_profile)
    end
  end
end


