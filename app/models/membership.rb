# == Schema Information
#
# Table name: memberships
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  challenge_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  bible_version :string(255)
#

class Membership < ActiveRecord::Base
  attr_accessible :challenge_id, :user_id, :bible_version

  belongs_to :user
  belongs_to :challenge

  validates :challenge_id, presence: true
  validates :bible_version, presence: true

  validates_uniqueness_of :user_id, scope: :challenge_id

  BIBLE_VERSIONS = %w(ASV ESV KJV NASB NKJV)

end
