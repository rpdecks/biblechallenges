class OneChapterBadge < Badge


  def name 
    "One Chapter Read"
  end

  def description
    "you get this badge when you have read one chapter"
  end

  def img
    "http://placehold.it/40x40"
  end

  def qualify?
    user.membership_readings.count > 0 
  end


end
