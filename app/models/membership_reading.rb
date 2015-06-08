class MembershipReading < ActiveRecord::Base
  # Scopes
  default_scope {includes(:reading).order('readings.read_on')}
  scope :punctual, -> {where(punctual: 1)}
  scope :not_punctual, -> {where(punctual: 0)}

  # Relations
  belongs_to :membership
  belongs_to :reading

  #delegations
  delegate :read_on, to: :reading

  # Validations
  validates :membership_id, presence: true
  validates :reading_id, presence: true

  #Callbacks
  before_create :mark_punctual

  def self.send_daily_emails
    MembershipReading.unread.joins(:reading).where("readings.date = ?",Date.today).each do |mr|
      puts "Sending email to: #{mr.membership.user.email} from #{mr.membership.challenge.name} challenge."
      MembershipReadingMailer.daily_reading_email(mr).deliver_now
    end
  end

  private

  def reading_punctual?
    self.reading.read_on.to_date === self.updated_at.to_date
  end

  def mark_punctual
    self.punctual = 1 if reading_punctual? 
  end
end
