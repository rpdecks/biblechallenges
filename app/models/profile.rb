class Profile < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :username, :time_zone, :preferred_reading_hour

  belongs_to :user
end
