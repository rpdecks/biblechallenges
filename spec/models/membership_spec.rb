require 'spec_helper'

describe Membership, "Relations" do
  it { should belong_to(:user) }
  it { should belong_to(:challenge) }
end
