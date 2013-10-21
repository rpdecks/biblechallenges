class Challenge < ActiveRecord::Base
  attr_accessible :begindate, :enddate, :name, :owner_id, :subdomain
end
