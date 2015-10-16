class ImportsMembersFromPreviousChallenge

  def initialize(challenge_with_members_to_import_id, challenge)
    @challenge_with_members_to_import = 
      Challenge.find(challenge_with_members_to_import_id) unless challenge_with_members_to_import_id.blank?
    @new_challenge = challenge
  end

  def import
    if challenge_exists_and_belongs_to_same_creator?
      MembershipGenerator.new(@new_challenge, @challenge_with_members_to_import.members).generate
    end
  end

  private

  def challenge_exists_and_belongs_to_same_creator?
    @challenge_with_members_to_import && challenges_owned_by_same?
  end

  def challenges_owned_by_same?
    @previous_challenge.owner == @new_challenge.owner
  end

end
