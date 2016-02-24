class Challenge < ActiveRecord::Base
  attr_accessor :previous_challenge_id
  serialize :date_ranges_to_skip  # array of ranges

  Rails.application.eager_load!
  ChallengeStatistic.descendants.each do |stat| 
    has_one stat.name.underscore.to_sym
  end

  include PgSearch
  pg_search_scope :search_by_name, against: :name
  scope :current, -> {where("enddate >= ?", Date.today)}
  scope :on_schedule_percentage, -> { joins(:challenge_statistics).where("challenge_statistics.type" => "ChallengeStatisticOnSchedulePercentage")}
  scope :no_nil_value, -> { joins(:challenge_statistics).where("challenge_statistics.value IS NOT NULL")}
  scope :top_8, -> { joins(:challenge_statistics).order("challenge_statistics.value desc").limit(8) }
  scope :at_least_5_members, -> { where("memberships_count >= ?", 5) }
  scope :newest_first, -> { order(begindate: :desc) }
  scope :no_members, -> { where("memberships_count = ?", 0) }

  scope :underway_at_least_x_days, lambda {|x| where("begindate < ?", Date.today - x.days) }

  scope :with_readings_tomorrow, -> { includes(:readings).where(readings: { read_on: Date.today+1 }) }
  scope :abandoned, -> { underway_at_least_x_days(7).no_members }
  scope :persisted, -> { where "id IS NOT NULL" }

  include FriendlyId
  # :history option: keeps track of previous slugs
  friendly_id :name, :use => [:slugged, :history]

  # Relations
  has_many :memberships, dependent: :destroy
  has_many :membership_statistics, through: :memberships

  has_many :members, through: :memberships, source: :user
  has_many :readings, dependent: :destroy
  has_many :membership_readings, through: :memberships  # needs default order #todo 
  has_many :groups
  has_many :chapters, through: :readings
  has_many :challenge_statistics, dependent: :destroy

  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  # Validations
  validates :begindate, presence: true
  validates :name, presence: true, length: {minimum: 3}
  validates :owner_id, presence: true
  validates :chapters_to_read, presence: true
  validate  :validate_dates
  validates :book_chapters, presence: true
  validate  :validate_days_of_week_to_skip

  # Callbacks

  before_validation :generate_book_chapters, :generate_date_ranges_to_skip
  before_save :generate_schedule

  after_commit :successful_creation_email, :on => :create


  def membership_for(user)
    user && memberships.find_by_user_id(user.id)
  end

  def associate_statistics #for the sample data rake task
    current_challenge_statistics = challenge_statistics.pluck(:type)
    all_statistics = ChallengeStatistic.descendants.map(&:name)
    missing_statistics = all_statistics - current_challenge_statistics
    missing_statistics.each do |s|
      challenge_statistics << s.constantize.create
    end
  end

  def update_stats #for the sample data rake task
    self.challenge_statistics.each do |cs|
      cs.update
    end
  end

  def has_member?(member)
    members.include?(member)
  end

  def has_ungrouped_member?(member)
    membership_for(member) && membership_for(member).group.nil?
  end

  def has_grouped_member?(member)
    membership_for(member) && membership_for(member).group
  end

  def is_over?
    self.enddate < Date.today
  end

  def percentage_completed
    scheduled = readings.where(read_on: (self.begindate)..(Date.today)).count
    total = readings.count
    scheduled.zero? ? 0 : (scheduled * 100) / total
  end

  # Accepts one or multiple users
  def join_new_member(userz,options={})
    if userz.class == Array
      userz.map {|u| join_new_member(u,options) }
    else
      membership = Membership.new
      membership.challenge =  self
      membership.user =  userz
      membership.user.update_attributes(bible_version: options[:bible_version]) unless options[:bible_version].blank?
      membership.save
      membership.update_stats
      membership
    end
  end

  def url
      "biblechallenges.com"
  end

  def generate_date_ranges_to_skip  # an array of date ranges
    self.date_ranges_to_skip = DateRangeParser.new(self.dates_to_skip).ranges
  end

  def generate_schedule
    self.schedule = ChaptersPerDateCalculator.new(self).schedule
    self.begindate = self.available_dates.first
    self.enddate = self.available_dates.last
  end

  def generate_book_chapters  # an array of [book,chapter] pairs, integers
    self.book_chapters = ActsAsScriptural.new.parse(chapters_to_read).chapters
  end

  def generate_readings
    ActsAsScriptural.new.parse(chapters_to_read).chapters.each_with_index do |chapter, i|
      chapter = Chapter.find_by_book_id_and_chapter_number(chapter.first, chapter.last)
      readings.create(chapter: chapter, read_on: (begindate + i.days))
    end
  end

  def todays_reading
    readings.find_by_read_on(Date.today)
  end

  def todays_readings(user)
    readings.where(read_on: user.date_by_timezone).limit(Reading::DAILY_LIMIT)
  end

  def all_users_emails
    all_members_in_challenge = self.members.where(:message_notify => true) #user_email_pref set to true to receive owner messages
    all_emails = all_members_in_challenge.pluck(:email)
    return all_emails
  end

  def send_challenge_msg_via_email(email_array, message, challenge)
      MessageUsersEmailWorker.perform_in(30.seconds, email_array, message, challenge)
  end

  def send_challenge_snapshot_email_to_members
    memberships.each {|m| m.send_challenge_snapshot_email}
  end

  private

  # Validations
  def validate_dates
    if enddate && begindate
      errors[:begin_date] << "and end date must be sequential" if enddate < begindate
    end
  end

  def validate_days_of_week_to_skip
    if self.days_of_week_to_skip.size == 7
      errors.add(:days_of_week_to_skip, "can't skip all seven days of the week")
    end
  end

  # Callbacks

  # before save
  # - after_create
  def successful_creation_email
    NewChallengeEmailWorker.perform_in(30.seconds, self.id)
  end

  def should_generate_new_friendly_id?
    # generate new slug whenever name changes
    name_changed? || slug.blank?
  end
end
