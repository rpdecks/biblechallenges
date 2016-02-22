class Reading < ActiveRecord::Base

  DAILY_LIMIT = 30

  # Relations
  belongs_to :challenge, counter_cache: true
  belongs_to :chapter
  has_many :membership_readings, dependent: :destroy
  has_many :memberships, through: :membership_readings
  has_many :comments, as: :commentable
  has_many :users, through: :memberships

  #delegations
  delegate :members, to: :challenge
  delegate :owner, to: :challenge

  delegate :book_and_chapter, to: :chapter

  # Validations
  validates :chapter_id, presence: true
  validates :challenge_id, presence: true
  validates :read_on, presence: true

  #Scopes
  scope :todays_readings, -> { where("read_on" => Date.today) }
  scope :tomorrows_readings, -> { where("read_on" => Date.today+1) }
  scope :to_date, lambda { | a_date | where("read_on <= ?", a_date) }
  scope :on_date, lambda { | a_date | where("read_on = ?", a_date) }

  def last_read_by
    #returns the user who last read this reading
    #last_reading.try(:membership).try(:user)
    nil #pdb
  end

  def read_by?(user)
    users.include?(user)
  end

  def membership_reading_for(membership)
    membership_readings.find_by_membership_id(membership.id)
  end

  def last_readers(num = 50)
    membership_readings.order("membership_readings.updated_at").limit(num).map {|r| r.membership.user}  #is this as ugly as it feels?  jose
  end

  def next_reading
    value = (challenge.readings.where("read_on >= ?", self.read_on).order(:chapter_id)).to_ary
    value.each do |v|
      return v unless v.chapter_id <= self.chapter_id
    end
  end

  def last_challenge_reading?
    return true if challenge.readings.last.chapter_id == self.chapter_id
  end

end
