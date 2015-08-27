class MembershipScore
  
  def initialize(membership)
    @membership = membership 
  end


  def score
    # decided to ignore streak sorry evan
    on_schedule = @membership.membership_statistic_on_schedule_percentage.value
    progress_percentage = @membership.membership_statistic_progress_percentage.value

    # I'm going to go with the score being the average of completion and on_schedule
    # this is easier to understand.

    # We can discuss changing this if we want to emphasize habit over content...

    return (progress_percentage + on_schedule) / 100.0
  end
end
