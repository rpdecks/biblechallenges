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
  validates :owner_id, presence: true
  validates :chapterstoread, presence: true

  validate :validate_enddate_before_begindate

  has_many :memberships
  has_many :members, through: :memberships
  has_many :readings

  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  private

  def validate_enddate_before_begindate
    if enddate && begindate
      errors[:enddate] << "The challenge begin and end dates must be sequential" if enddate < begindate
    end
  end


end
