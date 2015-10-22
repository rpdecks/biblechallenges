require 'spec_helper'

describe UserDecorator do

  describe "initialed_name" do
    it "for three names, shows first name and initials for other names" do
      user = build_stubbed(:user, name: "Skhor Tiberius Dilletante").decorate

      expect(user.initialed_name).to eq "Skhor T. D."
    end
    it "for one name, shows entire name" do
      user = build_stubbed(:user, name: "Lemonjello").decorate

      expect(user.initialed_name).to eq "Lemonjello"
    end
    it "for two names, shows first name and initial for 2nd name" do
      user = build_stubbed(:user, name: "Evan Koch").decorate

      expect(user.initialed_name).to eq "Evan K."
    end

  end
end

