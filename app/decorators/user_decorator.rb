class UserDecorator < Draper::Decorator
  include PrettyDate
  delegate_all

  def fullname
    "#{first_name} #{last_name}"
  end

  def show_progress_percentage(group)
    self.memberships.where(challenge_id: group.challenge.id).first.progress_percentage
  end

  def show_last_recorded_reading(group)
    self.memberships.where(challenge_id: group.challenge.id).first.membership_readings.last.created_at.to_pretty
  end
end
