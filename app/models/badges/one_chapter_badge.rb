class OneChapterBadge < Badge


  def name 
    "Five Chapters Read"
  end

  def description
    "you get this badge when you have read five chapters"
  end

  def img
    "http://placehold.it/40x40"
  end

  def qualify?
    user.membership_readings.read.count > 0 
  end


end
