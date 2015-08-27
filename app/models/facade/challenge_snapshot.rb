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

  def longest_individual_streaks
    # grab the top 5
   @challenge.membership_statistics.where(type: "MembershipStatisticRecordReadingStreak").top(5)
  end

  def top_readers
    @challenge.memberships.map{ |membership| MembershipScore.new(membership) }
  end

  def groups_and_scores
    @challenge.groups.map{ |g| [g.name, GroupScore.new(g).score] }
  end

  def group_names_by_average_score_highest_first
    groups_and_scores.sort_by {|group_and_score| group_and_score.last }.reverse.map {|group_and_score| group_and_score.first }
  end

  private

end
