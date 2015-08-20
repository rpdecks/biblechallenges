class FrontPageLeaderboard

  DEFAULT_LIMIT = 10

  def users_by_longest_all_time_streak
    User.joins(:user_statistic_days_read_in_a_row_all_time).
      order('user_statistics.value desc').limit(DEFAULT_LIMIT).decorate
  end

  def users_by_longest_current_streak
    User.joins(:user_statistic_days_read_in_a_row_current).
      order('user_statistics.value desc').limit(DEFAULT_LIMIT).decorate
  end

  def users_by_all_time_chapters
    User.joins(:user_statistic_chapters_read_all_time).
      order('user_statistics.value desc').limit(DEFAULT_LIMIT).decorate
  end

end
