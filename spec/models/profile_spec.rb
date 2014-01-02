require 'spec_helper'

describe Profile do

  describe "Relations" do
    it { should belong_to(:user) }
  end 

end
