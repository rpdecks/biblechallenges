class MembershipReading < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  NO_READING = "No readings yet"
  NO_CHAPTER = ""
  # Scopes
  default_scope {includes(:reading).order('readings.read_on')}
  scope :on_schedule, -> {where(on_schedule: 1)}
  scope :not_on_schedule, -> {where(on_schedule: 0)}
  scope :last_week, -> {where("#{table_name}.created_at > ?", Time.now - 8.days)}

  # Relations
  belongs_to :membership, :counter_cache => true
  belongs_to :chapter
  belongs_to :user
  belongs_to :reading

  #delegations
  delegate :read_on, to: :reading

  # Validations
  validates :membership_id, presence: true
  validates :reading_id, presence: true
  validates_uniqueness_of :membership_id, scope: :reading_id

  #Callbacks
  before_create :mark_on_schedule

  def self.most_recent
    order(:created_at).last || NoReading.new
  end

  def reading_time
    time_ago_in_words(self.created_at) + " ago"
  end

  private

  def reading_on_schedule?
    ZoneConverter.new.on_date_in_zone?(date: reading.read_on, timestamp: self.updated_at, timezone: membership.user.time_zone)
  end

  def mark_on_schedule
    self.on_schedule = 1 if reading_on_schedule? 
  end
end
