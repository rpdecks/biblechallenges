class Profile < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :username

  belongs_to :user
end
