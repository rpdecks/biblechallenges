# == Schema Information
#
# Table name: challenges
#
#  id             :integer          not null, primary key
#  owner_id       :integer
#  subdomain      :string(255)
#  name           :string(255)
#  begindate      :date
#  enddate        :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  chapterstoread :string(255)
#  active         :boolean          default(FALSE)
#

class Challenge < ActiveRecord::Base
  attr_accessible :begindate, :enddate, :name, :owner_id, :subdomain, :chapterstoread

  validates :begindate, presence: true
  validates :enddate, presence: true
  validates :name, presence: true, length: {minimum: 3}
  validates :subdomain, presence: true, uniqueness:  true
  validates_format_of   :subdomain,
                        with: /^[a-z\d]+(-[a-z\d]+)*$/i,
                        message: 'invalid format'

  validates :owner_id, presence: true
  validates :chapterstoread, presence: true

  validate :validate_dates

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :readings
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  before_validation :calculate_enddate, if: "enddate.nil? && !chapterstoread.blank?"
  after_create :successful_creation_email

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

  private

  def validate_dates
    if enddate && begindate
      errors[:begin_date] << "and end date must be sequential" if enddate < begindate
      errors[:begin_date] << "cannot be earlier than today" if begindate < Date.today
    end
  end

  def successful_creation_email
    ChallengeMailer.creation_email(self).deliver
  end

  def calculate_enddate
    response = Chapter.parse_query(chapterstoread)    
    self.enddate = begindate + response[1].length.days if response[1]
  end


end
