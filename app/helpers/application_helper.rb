module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type
      when "success"
        "alert-success"
      when "error"
        "alert-danger"
      when "alert"
        "alert-warning"
      when "notice"
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def avatar_url(user)
    # avatar = user upload
    # image = from facebook
    if user && user.avatar_file_name
      user.avatar.url(:thumb)
    else
      user.image || image_url('default_avatar.png')
    end
  end

  def select_options_for_bible
    [["ASV (American Standard)",'ASV'],["ESV (English Standard)",'ESV'],["KJV (King James)",'KJV'],["NASB (New American Standard)",'NASB'],["NKJV (New King James)",'NKJV'],["RCV (Recovery Version)", 'RCV']]
  end

  def react_chat(commentable, user = current_user)
    commentable_type = commentable.class.name
    react_component("CommentList", {
      commentableType: commentable_type, 
      commentableId: commentable.id, 
      comments: comments_json(commentable), 
      currentUser: current_user_json(user)
    })
  end

# I know this is gross but I'm leaving these helper examples in here; they are helpful
# raw [
#   tag('meta', property: 'og:image', content: image_url('ralph-gradient.png')),
#   tag('meta', property: 'og:url', content: url_for(only_path: false)),
#   tag('meta', property: 'og:title', content: page_title),
# ].join("\n")

# def trail_breadcrumbs(trail, separator = ">")
#   links = [
#     link_to("Trails", practice_path),
#     trail.topics.map { |topic| link_to(topic, topic) },
#     link_to(trail, trail),
#   ].flatten

#   links.join(" #{separator} ").html_safe
# end

end
