class ChallengeSnapshot

  def initialize(challenge)
    @challenge = challenge
    @top_half_limit = @challenge.memberships.size / 2
  end

  def groups_by_percentage_challenge_completed
    @challenge.groups.joins(:group_statistic_progress_percentage).
      order('group_statistics.value desc')
  end

  def groups_by_on_schedule_percentage
    @challenge.groups.joins(:group_statistic_on_schedule_percentage).
      order('group_statistics.value desc')
  end

  def memberships_by_percentage_challenge_completed
    @challenge.memberships.joins(:membership_statistic_progress_percentage).
      order('membership_statistics.value desc').limit(@top_half_limit)
  end

  def name
    @challenge.name
  end

  def members
    @challenge.members
  end

  def chapters
    @challenge.chapters.size
  end

  def total_chapters_read
    @challenge.membership_readings.all.size
  end

  def most_read_chapters
    arr = @challenge.membership_readings.pluck(:reading_id)
    arr.size == 1 ? chapter_ids = arr :  chapter_ids = modes(arr)  # private method below gets the mode/modes (most-read chapter_id/s)
    most_read = []
    if chapter_ids == nil
      return "No Readings Yet"
    else
      chapter_ids.each do |id|
        most_read << @challenge.readings.find_by_id(id).chapter.book_and_chapter
      end
      return most_read.to_sentence
    end
  end

  def longest_individual_streaks
    streaks = {}
    @challenge.memberships.each do |m|
      streak_stat = m.membership_statistic_record_reading_streak.value
      membership_hash = { m.user_id => streak_stat }
      streaks = streaks.merge(membership_hash)
    end
    max_streak_value = streaks.values.max
    streaks = streaks.select {|k,v| v == max_streak_value}
#      - @challenge_snapshot.longest_individual_streaks.each do |s|
#        - s.each {|k,v| puts "#{k}: #{v} days in a row"}
    streaks
  end

  def calculate_reader_score(streak, on_schedule, progress_percentage)
    calculation = (((streak / chapters / @challenge.num_chapters_per_day * @challenge.percentage_completed) * 25) + ((on_schedule / 100) * 50) + ((progress_percentage / @challenge.percentage_completed) * 25))
    return calculation
  end
  
  def top_readers
    tops = {}
    @challenge.memberships.each do |m|
      reader_score = calculate_reader_score(m.membership_statistic_record_reading_streak.value, m.membership_statistic_on_schedule_percentage.value, m.membership_statistic_progress_percentage.value)
      membership_hash = { m.user_id => reader_score }
      tops = tops.merge(membership_hash)
    end
    tops.sort_by {|k,v| v}.reverse
  end

  private

  def modes(arr, find_all = true)
    histogram = arr.inject(Hash.new(0)) { |h, n| h[n] += 1; h }
    modes = nil
    histogram.each_pair do |item, times|
      modes << item if modes && times == modes[0] and find_all
      modes = [times, item] if (!modes && times > 1) or (modes && times > modes[0])
    end
    return modes ? modes[1..modes.size] : modes
  end
end
