class CommentSerializer < ActiveModel::Serializer
	include ActionView::Helpers::DateHelper

  attributes :id, :content, :timeAgo, :user

  has_many :comments

  def timeAgo
    time_ago_in_words(object.created_at) + " ago"
  end

  def user
    {
    	id: object.user.id,
    	name: object.user.name,
    	avatar_path: '/assets/default_avatar.png'
    }
  end
end