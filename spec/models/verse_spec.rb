require 'spec_helper'

describe Verse, "Relations" do
  it { should belong_to(:chapter) }
end

describe Verse, "Validations" do
end

describe Verse, "Class methods" do

end


