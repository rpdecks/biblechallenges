class Group < ActiveRecord::Base

  belongs_to :user
  belongs_to :challenge
  has_many :memberships


  def punctual_reading_percentage_average
    sum_of_member_reading_averages = 0
    membership_count = self.memberships.count
    self.memberships.each do |m| 
      member = Membership.find(m.id)
      sum_of_member_reading_averages += member.punctual_reading_percentage
    end
    membership_count.zero? ? 0 : (sum_of_member_reading_averages) / membership_count
  end

  def average_progress_percentage
    sum_of_member_progress_percentages = 0
    membership_count = self.memberships.count
    self.memberships.each do |m| 
      member = Membership.find(m.id)
      sum_of_member_progress_percentages += member.progress_percentage
    end
    membership_count.zero? ? 0 : sum_of_member_progress_percentages / membership_count
  end

  def average_rec_sequential_reading_count
    sum_of_average_rec_sequential_reading_count = 0
    membership_count = self.memberships.count
    self.memberships.each do |m| 
      member = Membership.find(m.id)
      sum_of_average_rec_sequential_reading_count += member.rec_sequential_reading_count
    end
    membership_count.zero? ? 0 : sum_of_average_rec_sequential_reading_count / membership_count
  end

  def recalculate_stats
    self.ave_punctual_reading_percentage = punctual_reading_percentage_average
    self.ave_progress_percentage = average_progress_percentage
    self.ave_sequential_reading_count = average_rec_sequential_reading_count
    self.save
  end
end
