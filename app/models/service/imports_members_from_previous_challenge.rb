class ImportsMembersFromPreviousChallenge 
  def initialize(previous_challenge_id)
    @previous_challenge = Challenge.find(previous_challenge_id)
  end

  def import
    @previous_challenge.members
  end
end
