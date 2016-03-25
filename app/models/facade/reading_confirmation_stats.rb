class ReadingConfirmationStats

  attr_accessor :challenge

  INDIV_LIMIT = 5

  def initialize(membership, challenge)
    @membership = membership
    @challenge = challenge
  end

  def read_chapters_over_total_chapters
    "#{@membership.membership_readings.count}/#{total_chapters}"
  end

  def slug
    @challenge.slug
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

  def memberships_by_on_schedule_percentage
    @challenge.memberships.joins(:membership_statistic_on_schedule_percentage).
      order('membership_statistics.value desc').limit(INDIV_LIMIT)
  end

  def memberships_by_percentage_challenge_completed
    @challenge.memberships.joins(:membership_statistic_progress_percentage).
      order('membership_statistics.value desc').limit(INDIV_LIMIT)
  end

  def days_left
    dl = (@challenge.enddate - Date.today).to_i 
    (dl < 0) ? 0 : dl
  end

  def name
    @challenge.name
  end

  def total_members
    @challenge.members.size
  end

  def total_chapters
    @challenge.chapters.size
  end

  def total_chapters_read_by_challenge
    @challenge.membership_readings.size
  end

  def membership_statistic_name_value_pairs(type, limit)
    # return an array objects that respond to name and value
    stats = @challenge.membership_statistics.where(type: type).top(limit)
    stats.map{|s| OpenStruct.new(name: s.membership.name, value: s.value) }
  end

  def top_readers
    @challenge.memberships.map{ |membership| MembershipScore.new(membership) }
  end

  def groups_and_scores_highest_first
    groups_and_scores.sort_by {|group_and_score| group_and_score.last }.reverse
  end

  private

  def groups_and_scores
    @challenge.groups.map{ |g| [g.name, GroupScore.new(g).score] }
  end



end
