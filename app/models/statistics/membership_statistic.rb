class MembershipStatistic < ActiveRecord::Base

  belongs_to :membership
  has_one :challenge, through: :membership

  scope :top, lambda {|x| order("value desc").limit(x) }


  #overriding to_s lets us print out stats by simply printing the 
  #stat object
  def to_s
    value
  end


end
