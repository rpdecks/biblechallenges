class Group < ActiveRecord::Base

  belongs_to :user
  belongs_to :challenge
  has_many :memberships


  def punctual_reading_percentage_average
    sum_of_member_reading_averages = 0
    self.memberships.each do |m| 
      sum_of_member_reading_averages += m.punctual_reading_percentage
    end
    sum_of_member_reading_averages / self.memberships.count
  end
end
