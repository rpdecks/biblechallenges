class Challenge < ActiveRecord::Base
  serialize :date_ranges_to_skip  # array of ranges

  include PgSearch
  pg_search_scope :search_by_name, against: :name
  scope :current_challenges, -> {where("enddate >= ?", Date.today)}

  include FriendlyId
  # :history option: keeps track of previous slugs
  friendly_id :name, :use => [:slugged, :history]

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
  validate  :validate_dates
  validates :book_chapters, presence: true

  Rails.application.eager_load!
  ChallengeStatistic.descendants.each do |stat| 
    has_one stat.name.underscore.to_sym
  end

  # Callbacks
  before_validation :calculate_enddate,
    if: "(enddate.nil? && !chapters_to_read.blank?) || (!new_record? && (begindate_changed? || chapters_to_read_changed?))"
  before_validation :generate_book_chapters, :generate_date_ranges_to_skip
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

  def generate_date_ranges_to_skip  # an array of date ranges
    self.date_ranges_to_skip = DateRangeParser.new(self.dates_to_skip).ranges
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

  private

  # Validations
  def validate_dates
    if enddate && begindate
      errors[:begin_date] << "and end date must be sequential" if enddate < begindate
      #errors[:begin_date] << "cannot be earlier than today" if begindate < Date.today
    end
  end

  # Callbacks

  # before save
  # - after_create
  def successful_creation_email
    NewChallengeEmailWorker.perform_in(30.seconds, self.id)
  end

  # - before_validation
  def calculate_enddate
    chapters_count = ActsAsScriptural.new.parse(chapters_to_read).chapters.size
    self.enddate = begindate + (chapters_count - 1).days if chapters_to_read
  end

  def should_generate_new_friendly_id?
    # generate new slug whenever name changes
    name_changed?
  end
end
