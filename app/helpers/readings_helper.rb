module ReadingsHelper

  def already_read_by_avatars(reading)
    users = reading.last_readers
    avatarlist = ''
    users.each do |u|
      avatarlist += image_tag avatar_url(u), title: u.name, class: "img-circle"
    end
    raw avatarlist
  end

  def reading_css(reading)
    reading.read_by?(current_user) ? 'read' : 'unread'
  end

end
