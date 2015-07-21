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
    user.avatar || user.image || image_url('default_avatar.png')
  end

  def select_options_for_bible
    [["ASV (American Standard)",'ASV'],["ESV (English Standard)",'ESV'],["KJV (King James)",'KJV'],["NASB (New American Standard)",'NASB'],["NKJV (New King James)",'NKJV']]
  end

end
