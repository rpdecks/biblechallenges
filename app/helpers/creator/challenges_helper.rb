module Creator::ChallengesHelper

  def challenge_status_button
    if @challenge.active?
      "<h3 style='margin-top: 0px;'><span class='label label-success'>Activated</span></h3>".html_safe
    else
      button_to 'Activate my Challenge', activate_creator_challenge_path(@challenge), class: 'btn btn-primary btn-sm', method: 'get'
    end
  end

  def botton_availability
    if @challenge.active?
      "disabled"
    end
  end

end
