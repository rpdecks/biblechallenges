require 'spec_helper'

RSpec.describe Badge, type: :model do
  describe "associations" do
    it {should belong_to(:user) }
  end

  describe "Class Methods" do
    describe "attach_user_badges(user)" do
      it "should add any existing badges to a user if he doesn't have them" do
      user = create(:user)

      expect(user.badges).to be_empty
      Badge.attach_user_badges(user)
      expect(user.badges.size).to eq Badge.descendants.size
      end
    end
  end
end
