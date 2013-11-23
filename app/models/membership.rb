# == Schema Information
#
# Table name: memberships
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  challenge_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  email         :string(255)
#  username      :string(255)
#  firstname     :string(255)
#  lastname      :string(255)
#  bible_version :string(255)
#

class Membership < ActiveRecord::Base
  attr_accessible :challenge_id, :user_id, :username, :firstname, :lastname, :email, :bible_version

  belongs_to :user
  belongs_to :challenge

  validates :email, presence: true
  validates :challenge_id, presence: true
  validates :bible_version, presence: true
  validates :username, presence: true, on: :update
  validates :firstname, presence: true, on: :update
  validates :lastname, presence: true, on: :update

  validates_uniqueness_of :user_id, scope: :challenge_id
#  validates_format_of :email, :with => /@/, message: "doesn't really look like a real email address"
#  validates_uniqueness_of :username, scope: :challenge_id, on: :update

  BIBLE_VERSIONS = %w(ASV ESV KJV NASB NKJV)

end
