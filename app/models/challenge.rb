class Challenge < ActiveRecord::Base
  attr_accessible :begindate, :enddate, :name, :owner_id, :subdomain

  validates :begindate, presence: true
  validates :enddate, presence: true
  validates :name, presence: true
  validates :subdomain, presence: true
  validates :owner_id, presence: true

end
