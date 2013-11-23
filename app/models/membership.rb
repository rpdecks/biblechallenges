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

  attr_accessible :challenge, :user, :bible_version

  BIBLE_VERSIONS = %w(ASV ESV KJV NASB NKJV)

  belongs_to :user
  belongs_to :challenge

  validates :challenge_id, presence: true
  validates :bible_version, presence: true

  validates_uniqueness_of :user_id, scope: :challenge_id
  validates :bible_version, inclusion: {in: BIBLE_VERSIONS}

end