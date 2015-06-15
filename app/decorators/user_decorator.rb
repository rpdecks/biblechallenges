class UserDecorator < Draper::Decorator
  include PrettyDate
  delegate_all

  def fullname
    "#{first_name} #{last_name}"
  end

  def show_progress_percentage(membership)
    self.memberships.find(membership).progress_percentage
  end

  def show_last_recorded_reading(membership)
    self.memberships.find(membership).membership_readings.last.created_at.to_pretty
  end
end
