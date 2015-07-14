class Challenge < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_name, against: :name

  # Relations
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :readings, dependent: :destroy
  has_many :membership_readings, through: :memberships  # needs default order #todo 
  has_many :groups
  has_many :chapters, through: :readings
  has_many :challenge_statistics

  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  # Validations
  validates :begindate, presence: true
  validates :name, presence: true, length: {minimum: 3}
  validates :owner_id, presence: true
  validates :chapters_to_read, presence: true
  validates_format_of :chapters_to_read,
                        with: /\A\s*([0-9]?\s*[a-zA-Z]+)\.?\s*([0-9]+)(?:\s*(?:-|..)[^0-9]*([0-9]+))?/,
                        message: 'invalid format'
  validate  :validate_dates

  Rails.application.eager_load!
  ChallengeStatistic.descendants.each do |stat| 
    has_one stat.name.underscore.to_sym
  end

  # Callbacks
  before_validation :calculate_enddate,
    if: "(enddate.nil? && !chapters_to_read.blank?) || (!new_record? && (begindate_changed? || chapters_to_read_changed?))"
  after_create      :successful_creation_email
  #after_create      :joins_creator_to_challenge
  #after_save        :generate_readings


  def joins_creator_to_challenge   #todo this needs to be in the controller not a callback
    user = User.find(self.owner_id)
    membership = Membership.new
    membership.user = user
    membership.challenge = self
    membership.save
    MembershipCompletion.new(membership)
  end

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
    challenge_statistics.each do |cs|
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
      membership.bible_version = options[:bible_version] unless options[:bible_version].blank?
      membership.save
      membership
    end
  end

  def url
      "biblechallenges.com"
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

  private

  # Validations
  def validate_dates
    if enddate && begindate
      errors[:begin_date] << "and end date must be sequential" if enddate < begindate
      errors[:begin_date] << "cannot be earlier than today" if begindate < Date.today
    end
  end

  def changes_allowed_when_activated
    if begindate_changed? || chapters_to_read_changed? || enddate_changed?
      errors[:change_not_allowed] << "because this challenge is active"
    end
  end

  # Callbacks

  # before save
  # - after_create
  def successful_creation_email
    ChallengeMailer.delay.creation_email(self.id)
  end

  # - before_validation
  def calculate_enddate
    chapters_count = ActsAsScriptural.new.parse(chapters_to_read).chapters.size
    self.enddate = begindate + (chapters_count - 1).days if chapters_to_read
  end


end
