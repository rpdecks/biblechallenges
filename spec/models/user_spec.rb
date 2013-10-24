require 'spec_helper'

describe User, "Relations" do
  it { should have_many(:challenges) }
end
