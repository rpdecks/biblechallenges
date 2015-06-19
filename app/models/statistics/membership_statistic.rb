class MembershipStatistic < ActiveRecord::Base

  belongs_to :membership


  #overriding to_s lets us print out stats by simply printing the 
  #stat object
  def to_s
    value
  end

  # a default value; this should be overriden in subclasses
  def value
    ""
  end

end
