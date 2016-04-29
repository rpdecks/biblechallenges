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

  def commentable_belongs_to_user
    if commentable_type == "Reading"
      unless commentable.members.find_by_id user.id
        errors.add(:user_id, " cannot comment upon something you do not own.")
      end
    end
  end

end
