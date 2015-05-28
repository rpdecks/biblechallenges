class Challenge < ActiveRecord::Base

  # Relations
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :readings, dependent: :destroy
  has_many :membership_readings, through: :members  # needs default order #todo 
  has_many :groups

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

  # Callbacks
  before_validation :calculate_enddate,
    if: "(enddate.nil? && !chapters_to_read.blank?) || (!new_record? && (begindate_changed? || chapters_to_read_changed?))"
  after_create      :successful_creation_email
  #after_save        :generate_readings



  def membership_for(user)
    user && memberships.find_by_user_id(user.id)
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
    scheduled = readings.where(date: (self.begindate)..(Date.today)).count
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
    readings.destroy_all

    ActsAsScriptural.new.parse(chapters_to_read).chapters.each_with_index do |chapter, i|
      chapter = Chapter.find_by_book_id_and_chapter_number(chapter.first, chapter.last)
      readings.create(chapter: chapter, date: (begindate + i.days))
    end
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
    ChallengeMailer.creation_email(self).deliver_now
  end

  # - before_validation
  def calculate_enddate
    chapters_count = ActsAsScriptural.new.parse(chapters_to_read).chapters.size
    self.enddate = begindate + (chapters_count - 1).days if chapters_to_read
  end


end
