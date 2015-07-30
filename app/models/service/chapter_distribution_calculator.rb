class ChapterDistributionCalculator

  attr_reader :distribution

  # given a number of days and a number of chapters, returns an array that shows
  # how many chapters should be on each of the days
  def initialize(num_days:, num_chapters:)
    @num_days = num_days
    @num_chapters = num_chapters
    @distribution = []

    if num_days.zero? || num_chapters.zero?
      return
    else
      calculate_distribution
    end
  end

  def calculate_distribution
    add_gapless_distributions
    add_remainder
  end


  def add_gapless_distributions
    quotient = @num_chapters / @num_days
    @num_days.times do
      @distribution << quotient
    end
  end

  def add_remainder
    remainder = @num_chapters % @num_days
    interval_size = (@num_days.to_f / remainder.to_f)

    count = 0
    remainder.times do
      @distribution[count.floor] = @distribution[count.floor] + 1
      count += interval_size
    end
  end

end
