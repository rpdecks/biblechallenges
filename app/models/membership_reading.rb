class MembershipReading < ActiveRecord::Base
  # Scopes
  default_scope {includes(:reading).order('readings.read_on')}
  scope :on_schedule, -> {where(on_schedule: 1)}
  scope :not_on_schedule, -> {where(on_schedule: 0)}

  # Relations
  belongs_to :membership
  belongs_to :reading

  #delegations
  delegate :read_on, to: :reading

  # Validations
  validates :membership_id, presence: true
  validates :reading_id, presence: true

  #Callbacks
  before_create :mark_on_schedule

  def self.send_daily_emails
    MembershipReading.unread.joins(:reading).where("readings.date = ?",Date.today).each do |mr|
      puts "Sending email to: #{mr.membership.user.email} from #{mr.membership.challenge.name} challenge."
      MembershipReadingMailer.daily_reading_email(mr).deliver_now
    end
  end

  private

  def reading_on_schedule?
    ZoneConverter.new.on_date_in_zone?(date: reading.read_on, timestamp: self.updated_at, timezone: membership.user.profile.time_zone)
  end

  def mark_on_schedule
    self.on_schedule = 1 if reading_on_schedule? 
  end
end
