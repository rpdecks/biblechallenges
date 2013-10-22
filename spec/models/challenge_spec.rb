require 'spec_helper'

describe Challenge, "Validations" do
  it { should validate_presence_of(:begindate) }
  it { should validate_presence_of(:enddate) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner_id) }
  it { should validate_presence_of(:subdomain) }
end
