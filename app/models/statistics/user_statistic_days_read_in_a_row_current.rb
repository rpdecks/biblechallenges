class UserStatisticDaysReadInARowCurrent < UserStatistic

  def name
    "Current streak for days read in a row"
  end

  def description
    "Records the active streak of consecutive days with a membership reading, regardless of challenge."
  end

  def most_recent_streak
    @streaks.last
  end

  def most_recent_day_in_most_recent_streak
    most_recent_streak.last
  end

  def calculate
    streak = 0
    yesterday_jd = Time.current.utc.yesterday.to_date.jd
    today_jd = Time.current.utc.to_date.jd

    dates_read = user.membership_readings.reload.map do |r|
      r.created_at.utc.to_date.jd  # converts days to integers
    end
    dates_read.sort!  # dates as integers in ascending order

    # find_consecutive doesn't count one day streaks so this is a
    # special case to check for.  if a bigger streak is in the works
    # the value of streak will be overwritten by it
    if  [yesterday_jd, today_jd].include? dates_read.last
      streak = 1
    end

    @streaks = dates_read.uniq.find_consecutive

    if @streaks.any? &&
      ([yesterday_jd, today_jd].include? most_recent_day_in_most_recent_streak)
      streak = most_recent_streak.size
    end

    return streak
  end

  def update
    self.value = calculate
    save
  end
end
