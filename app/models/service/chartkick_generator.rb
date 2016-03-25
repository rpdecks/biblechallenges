class ChartkickGenerator

  def initialize(challenge, membership, options={})
    @membership = membership
    @challenge = challenge
    @options = options
    generate
  end

  def generate

  end

  def member_data
    @membership.update_stats

  end

  def benchmark_data

  end
end
