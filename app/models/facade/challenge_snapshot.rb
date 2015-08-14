class ChallengeSnapshot

  def initialize(challenge)
    @challenge = challenge
  end


  def groups_by_percentage_challenge_completed
    @challenge.groups.joins(:group_statistic_progress_percentage).
      order('group_statistics.value desc')
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
