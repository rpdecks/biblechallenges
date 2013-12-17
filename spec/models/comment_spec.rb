require 'spec_helper'

describe Comment do
  describe "Validations" do
    it { should validate_presence_of(:user)}
    it { should validate_presence_of(:content)}
  end

  describe "Relations" do
    it { should belong_to(:user) }
    it { should belong_to(:commentable) }
  end

end
