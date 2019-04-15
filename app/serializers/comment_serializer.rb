class CommentSerializer < ActiveModel::Serializer
	include ActionView::Helpers::DateHelper

  root false
  attributes :id, :content, :timeAgo

  has_one :user
  has_many :comments

  def timeAgo
    time_ago_in_words(object.created_at) + " ago"
  end
end