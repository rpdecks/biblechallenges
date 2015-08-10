class ChallengeStatisticProgressPercentage < ChallengeStatistic

  def name
    "Challenge Progress Percentage"
  end

  def description
    "Percentage of the challenge completed by all members of the challenge in total"
  end

  def calculate
    total = progress_percentages_for_all_members.inject(0,:+)
    members_in_challenge.zero? ? 0 : total / members_in_challenge
  end

  def members_in_challenge
    @members_in_challenge ||= challenge.reload.memberships.size
  end

  def progress_percentages_for_all_members
    # the to_i at the end converts any nils to 0.  Shouldn't have nil values for this stat
    # but it crops up
    challenge.reload.memberships.map{|m| m.membership_statistic_progress_percentage.try(:value).to_i}
  end

  def update
    self.value = calculate
    save
  end

end
