class GroupStatistic < ActiveRecord::Base

  belongs_to :group


  def to_s
    value
  end



end
