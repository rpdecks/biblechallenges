class FrontPageLeaderboard

  include ActionView::Helpers::DateHelper
  include ApplicationHelper

  DEFAULT_LIMIT = 10
  CHAPTERS_READ_LIMIT = 8

  def users_by_longest_all_time_streak
    User.includes(:user_statistic_days_read_in_a_row_all_time).
      order('user_statistics.value desc').limit(DEFAULT_LIMIT).decorate
  end

  def users_by_longest_current_streak
    User.includes(:user_statistic_days_read_in_a_row_current).
      order('user_statistics.value desc').limit(DEFAULT_LIMIT).decorate
  end

  def users_by_all_time_chapters
    User.includes(:user_statistic_chapters_read_all_time).
      order('user_statistics.value desc').limit(DEFAULT_LIMIT).decorate
  end

  def users_by_most_recent_reading
    # gonna make an easy access collection here :)
    most_recent_membership_readings.map do |mr|
      user = OpenStruct.new
      user.user = mr.user
      user.initialed_name = mr.user.decorate.initialed_name
      user.chapter_number = mr.chapter.chapter_number
      user.book_name = mr.chapter.book_name
      user.time_ago = time_ago_in_words(mr.created_at) + " ago"
      user
    end
  end

  def weeks_most_read_chapter
    arr = MembershipReading.last_week.pluck(:reading_id)
    arr.size == 1 ? chapter_ids = arr : chapter_ids = modes(arr)
    most_read = []
    if chapter_ids == nil
      return "No Readings this week"
    else
      chapter_ids.each do |id|
        most_read << Reading.find_by_id(id).chapter.book_and_chapter
      end
    most_read.to_sentence
    end
  end

  private

  def most_recent_membership_readings
    MembershipReading.unscoped.
      joins(:user, :reading, :chapter).
      order('membership_readings.created_at desc').limit(CHAPTERS_READ_LIMIT)
  end

  def modes(arr)
    histogram = arr.inject(Hash.new(0)) { |h, n| h[n] += 1; h }
    modes = nil
    histogram.each_pair do |item, times|
      modes << item if modes && times == modes[0]
      modes = [times, item] if (!modes && times > 1) or (modes && times > modes[0])
    end
    return modes ? modes[1..modes.size] : modes
  end

end
