class Reading < ActiveRecord::Base

  # Relations
  belongs_to :challenge
  belongs_to :chapter
  has_many :membership_readings, dependent: :destroy
  has_many :memberships, through: :membership_readings
  has_many :comments, as: :commentable
  has_many :users, through: :memberships

  #delegations
  delegate :members, to: :challenge
  delegate :owner, to: :challenge
  # Validations
  validates :chapter_id, presence: true
  validates :challenge_id, presence: true
  validates :read_on, presence: true

  #Scopes
  scope :todays_reading, -> { where("read_on" => Date.today) }
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
end
