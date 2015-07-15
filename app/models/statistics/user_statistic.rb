class UserStatistic < ActiveRecord::Base
  belongs_to :user

  def to_s
    value
  end



end
