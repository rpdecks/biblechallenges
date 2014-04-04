class Comment < ActiveRecord::Base
  attr_accessible :commentable_id, :commentable_type, :content, :flag_count, :invisible, :user_id


  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :comments, as: :commentable

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 1000}

  validate :commentable_belongs_to_user

  def commentable_belongs_to_user
    if commentable_type == "Reading"
      unless commentable.members.find_by_id user.id
        errors.add(:user_id, " cannot comment upon something you do not own.")
      end
    end
  end

end
