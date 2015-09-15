require 'spec_helper'

RSpec.describe Group, type: :model do
  describe "Relations" do
    it { should belong_to(:challenge)} 
    it { should belong_to(:user)} 
    it { should have_many(:memberships)} 
  end

  describe "Validations" do
    it { should validate_presence_of(:challenge)} 
  end

end
