# == Schema Information
#
# Table name: challenges
#
#  id               :integer          not null, primary key
#  owner_id         :integer
#  subdomain        :string(255)
#  name             :string(255)
#  begindate        :date
#  enddate          :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  chapters_to_read :string(255)
#  active           :boolean          default(FALSE)
#

class Challenge < ActiveRecord::Base
  attr_accessible :begindate, :enddate, :name, :owner_id, :subdomain, :chapters_to_read, :public, :welcome_message

  # Relations
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :readings, dependent: :destroy
  has_many :membership_readings, through: :readings  # needs default order #todo 

  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  # Validations
  validates :begindate, presence: true
  validates :name, presence: true, length: {minimum: 3}
  validates :subdomain, presence: true, uniqueness:  true
  validates_format_of  :subdomain,
                        with: /\A[a-z\d]+(-[a-z\d]+)*\z/i,
                        message: 'invalid format'
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
  after_save        :generate_readings

  scope :non_private, -> { where(public: true) }  # illegal scope name in rails 4.1+

  def subdomain= subdomain
    subdomain.gsub!(/\s+/, "") if subdomain
    super(subdomain.try(:downcase))
  end

  def membership_for(user)
    memberships.find_by_user_id(user.id)
  end

  def has_member?(member)
    members.include?(member)
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

  def welcome_message_markdown
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(self.welcome_message || "")
  end

  def url
    if subdomain
      subdomain + ".biblechallenges.com"
    else
      "biblechallenges.com"
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

  def generate_readings
    # Only generate the reading on the cases below.
    if (id_changed? || begindate_changed? || chapters_to_read_changed?)
      readings.destroy_all
      Chapter.search(chapters_to_read).flatten.each_with_index do |chapter,i|
        readings.create(chapter: chapter, date: (begindate + i.days))
      end
    end
  end

  # - before_validation
  def calculate_enddate
    chapters_count = Parser.separate_queries(chapters_to_read).inject(0) do |chapters, query|
      chapters += (Parser.parse_query(query)[1].try(:length) || 0)
    end
    self.enddate = begindate + (chapters_count - 1).days if chapters_to_read
  end


end
