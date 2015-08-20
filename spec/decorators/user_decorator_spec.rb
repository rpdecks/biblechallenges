require 'spec_helper'

describe UserDecorator do

  describe "initialed_name" do
    it "shows last name and initials for three names" do
      user = build_stubbed(:user, name: "Evan Tiberius Koch").decorate

      expect(user.initialed_name).to eq "E. T. Koch"
    end
    it "shows last name and initials for one name" do
      user = build_stubbed(:user, name: "Kochster").decorate

      expect(user.initialed_name).to eq "Kochster"
    end
    it "shows last name and initials for two names" do
      user = build_stubbed(:user, name: "Evan Koch").decorate

      expect(user.initialed_name).to eq "E. Koch"
    end

  end
end

