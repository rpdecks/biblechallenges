class ChallengeSnapshot

  def initialize(challenge)
    @challenge = challenge
    @top_limit = Math.sqrt(@challenge.memberships.size).round
  end
  
  def any_groups?
    @challenge.groups.any?
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
      order('membership_statistics.value desc').limit(@top_limit)
  end

  def membership_readings_last_week
    @challenge.membership_readings.last_week
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
    binding.pry
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

  def most_read_chapters_last_week
    arr = membership_readings_last_week.pluck(:reading_id)
    arr.size == 1 ? chapter_ids = arr :  chapter_ids = modes(arr)  # private method below gets the mode/modes (most-read chapter_id/s)
    most_read = []
    if chapter_ids == nil
      return "No Readings last week"
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
      membership_hash = { m.user.name => streak_stat }
      streaks = streaks.merge(membership_hash)
    end
    max_streak_value = streaks.values.max
    streaks = streaks.select {|k,v| v == max_streak_value}
#      - @challenge_snapshot.longest_individual_streaks.each do |s|
#        - s.each {|k,v| puts "#{k}: #{v} days in a row"}
    streaks
  end

  def calculate_reader_score(membership)
    streak = membership.membership_statistic_record_reading_streak.value
    on_schedule = membership.membership_statistic_on_schedule_percentage.value
    progress_percentage = membership.membership_statistic_progress_percentage.value

    streak == 0 ? streak = 1 : streak
    completed = @challenge.percentage_completed
    completed == 0 ? completed = 1 : completed
    calculation = (((chapters / completed / @challenge.num_chapters_per_day / streak) * 1) + ((on_schedule / 4) * 3) + ((progress_percentage / completed * 25) * 2)) # coefficients {/4 & *25} are decided
                                        # so that Total Score is 3 parts on_schedule
                                        # and 1 parts _streak & 2 parts _progress_percent
    return calculation
  end
  
  def top_readers
    tops = {}
    @challenge.memberships.each do |m|
      reader_score = calculate_reader_score(m)
      membership_hash = { m.user.name => reader_score }
      tops = tops.merge(membership_hash)
    end
    tops.keys.sort_by {|k,v| v}.reverse.take(@top_limit) #remove 'keys' to return both name and score hash elements.
  end

  def group_average_score(group)
    group_size = group.members.size
    total_score = 0

    group.memberships.each do |m|
      puts m.user.name
      puts "score is #{calculate_reader_score(m)}"
      total_score += calculate_reader_score(m)
    end

    return total_score / group_size
  end

  def groups_and_scores
    result = Array.new

    @challenge.groups.each do |g|
      result << [g.name, group_average_score(g)]
    end
    return result
  end

  def group_names_by_average_score_highest_first
    groups_and_scores.sort_by {|group_and_score| group_and_score.last }.reverse.map {|group_and_score| group_and_score.first }
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
