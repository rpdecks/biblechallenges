class ImportsMembersFromPreviousChallenge

  def initialize(challenge_with_members_to_import_id, challenge)
    @previous_challenge = Challenge.find(challenge_with_members_to_import_id) if challenge_with_members_to_import_id
    @new_challenge = challenge
  end

  def import
    if challenge_exists_and_belongs_to_same_creator?
      MembershipGenerator.new(@new_challenge, @previous_challenge.members).generate 
    end
  end

  private

  def challenge_exists_and_belongs_to_same_creator?
    @previous_challenge && (@previous_challenge.owner == @new_challenge.owner)
  end
end
