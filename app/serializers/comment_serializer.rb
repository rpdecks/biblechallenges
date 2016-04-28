class CommentSerializer < ActiveModel::Serializer
	include ActionView::Helpers::DateHelper

  attributes :id, :content, :timeAgo, :userName

  has_many :comments

  def timeAgo
    time_ago_in_words(object.created_at) + " ago"
  end

  def userName
    object.user.name
  end
end