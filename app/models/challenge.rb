class Challenge < ActiveRecord::Base
  attr_accessible :begindate, :enddate, :name, :owner_id, :subdomain

  validates :begindate, presence: true
  validates :enddate, presence: true
  validates :name, presence: true, length: {minimum: 3}
  validates :subdomain, presence: true, uniqueness:  true
  validates :owner_id, presence: true

  validate :validate_enddate_before_begindate

  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :memberships
  has_many :members, through: :memberships

  def validate_enddate_before_begindate
    if enddate && begindate
      errors[:enddate] << "The challenge begin and end dates must be sequential" if enddate < begindate
    end
  end


end
