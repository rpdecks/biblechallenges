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

  def total_chapters_read
    @challenge.membership_readings.all.size
  end

  def most_read_chapters
    arr = @challenge.membership_readings.pluck(:reading_id)
    arr.size == 1 ? chapter_ids = arr :  modes(arr)  # private method below, gets chapter_id of most read chaps
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

  def longest_individual_streak

  end

  def top_reader

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
