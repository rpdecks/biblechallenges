module CommentsHelper
  def comments_json(commentable_object)
    if commentable_object
      eval(ActiveModel::ArraySerializer.new(commentable_object.comments.recent_last,
                                            each_serializer: CommentSerializer).to_json)
    end
  end

  def current_user_json(user = current_user)
    if user
      eval(UserSerializer.new(user).to_json)
    end
  end
end
