class Comment < ActiveRecord::Base
  attr_accessible :commentable_id, :commentable_type, :content, :flag_count, :invisible, :user_id


  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 1000}
  
end
