require 'spec_helper'

describe Chapter, "Relations" do
  it { should have_many(:challenges).through(:chapter_challenges) }
  it { should have_many(:chapter_challenges) }
end

describe Chapter, "Validations" do
end
