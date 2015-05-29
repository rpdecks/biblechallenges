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
  validates :date, presence: true

  #Scopes
  scope :to_date, lambda { | a_date | where("date <= ?", a_date) }


  def last_read_by
    #returns the user who last read this reading
    #last_reading.try(:membership).try(:user)
    nil #pdb
  end

  def read_by?(user)
    users.include?(user)
  end

  def last_readers(num = 50)
    membership_readings.order("membership_readings.updated_at").limit(num).map {|r| r.membership.user}  #is this as ugly as it feels?  jose
  end
end
