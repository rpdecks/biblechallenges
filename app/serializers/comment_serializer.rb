class CommentSerializer < ActiveModel::Serializer
	include ActionView::Helpers::DateHelper
  include ApplicationHelper
  include ActionView::Helpers::AssetUrlHelper

  attributes :id, :content, :timeAgo, :user

  has_many :comments

  def timeAgo
    time_ago_in_words(object.created_at) + " ago"
  end

  def user
    user = object.user

    {
    	id: user.id,
    	name: user.name,
      avatar_path: avatar_url(user)
    }
  end
end