require 'spec_helper'

describe Comment do
  describe "Validations" do
    it { should validate_presence_of(:user)}
    it { should validate_presence_of(:content)}
    it { should ensure_length_of(:content).is_at_most(1000)}

    #this seems like a retarded way to determine ownership of a commentable by a user. ask jose
    it "should ensure a reading comment is from a member of the reading" do
      challenge = create(:challenge)
      reading = create(:reading, challenge: challenge)
      random_user = create(:user)
      newcomment = FactoryGirl.build(:reading_comment, user: random_user, commentable: reading)
      expect(newcomment).to have(1).errors_on(:user_id)
    end

  end

  describe "Relations" do
    it { should belong_to(:user) }
    it { should belong_to(:commentable) }
    it { should have_many(:comments) }
  end

end
