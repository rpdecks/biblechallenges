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




  def total_chapters
    @challenge.chapters.size
  end

  def name
    @challenge.name
  end

  def most_read_chapter

  end

  def longest_individual_streak

  end

  def top_reader

  end


end
