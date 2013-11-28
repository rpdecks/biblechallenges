# == Schema Information
#
# Table name: membership_readings
#
#  id            :integer          not null, primary key
#  membership_id :integer
#  reading_id    :integer
#  state         :string(255)      default("unread")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class MembershipReading < ActiveRecord::Base
  attr_accessible :reading, :membership, :state

  # Scopes
  scope :read, -> {where(state: 'read')}
  scope :unread, -> {where(state: 'unread')}

  # Constants 
  STATES = %w(read unread)

  # Relations
  belongs_to :membership
  belongs_to :reading
  
  # Validations
  validates :membership_id, presence: true
  validates :reading_id, presence: true
  validates :state, inclusion: {in: STATES}

  def hash_for_url
    HashidsGenerator.instance.encrypt(id)
  end

end