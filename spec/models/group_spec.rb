require 'spec_helper'

RSpec.describe Group, type: :model do
  describe "Relations" do
    it { should belong_to(:challenge)} 
    it { should belong_to(:user)} 
    it { should have_many(:memberships)} 
  end

end
