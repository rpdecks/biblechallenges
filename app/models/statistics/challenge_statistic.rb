class ChallengeStatistic < ActiveRecord::Base
  belongs_to :challenge

  def to_s
    value
  end



end
