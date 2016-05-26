class Comment < ActiveRecord::Base


  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :comments, -> {order(:created_at)}, as: :commentable

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 1000}

  validate :commentable_belongs_to_user


  def self.recent_first
    order('created_at desc')
  end

  def self.recent_last
    order(:created_at)
  end

  private

  def commentable_belongs_to_user
    if not check_user_permission(commentable)
      errors.add(:base, "You cannot comment upon something that you are not related to")
    end
  end

  def check_user_permission(commentable)
    case commentable.class.to_s
      when "Challenge"
        commentable.has_member?(user)
      when "Reading"
        commentable.challenge.has_member?(user)
      when "Group"
        commentable.has_member?(user)
      when "Comment"
        check_user_permission(commentable.commentable) # call recursively
      else
        false
    end
  end
end