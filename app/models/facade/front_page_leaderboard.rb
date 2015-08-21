class FrontPageLeaderboard

  include ActionView::Helpers::DateHelper
  include ApplicationHelper

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

  def users_by_most_recent_reading
    # gonna make an easy access collection here :)
    most_recent_membership_readings.map do |mr|
      user = OpenStruct.new
      user.user = mr.user
      user.initaled_name = mr.user.decorate.initialed_name
      user.chapter_number = mr.chapter.chapter_number
      user.book_name = mr.chapter.book_name
      user.time_ago = time_ago_in_words(mr.created_at) + " ago"
      user
    end
  end

  private

  def most_recent_membership_readings
    MembershipReading.unscoped.
      joins(:user, :reading, :chapter).
      order('membership_readings.created_at desc').limit(DEFAULT_LIMIT)
  end


end
