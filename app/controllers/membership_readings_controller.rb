class MembershipReadingsController < ApplicationController
  respond_to :html, :json
  acts_as_token_authentication_handler_for User, only: [:create]
  before_filter :authenticate_user!, except: [:confirmation] # needs to follow token_authentication_handler

  layout 'from_email'

  def create
    @challenge = membership.challenge

    if @challenge.has_member?(current_user) && membership.user == current_user

      readings.each do |reading|
        @membership_reading = MembershipReading.new(membership_id: membership_reading_params[:membership_id],
                                                    reading_id: reading.id)
        if @membership_reading.save
          MembershipReadingCompletion.new(current_user, membership, @membership_reading).attach_attributes
          update_stats
        end
      end

      respond_to do |format|
        format.html {
          if params[:source] == "email"
            redirect_to confirmation_membership_reading_path(id: readings.pluck(:id), membership_id: membership.id)
          else
            redirect = params[:location] || request.referer
            redirect += params[:anchor] if params[:anchor]
            redirect_to redirect
          end
        }
        format.json {
          render json: @membership_reading
        }
      end
    else
      raise "Not allowed"
    end
  end

  def update_stats
    UpdateStatsWorker.perform_in(5.seconds, membership.id)
  end

  def destroy
    @membership = membership_reading.membership
    @challenge = @membership.challenge
    if @challenge.has_member?(current_user) && @membership.user == current_user

      membership_reading.destroy

      update_stats

      respond_to do |format|
        format.html { 
          # go back to referer unless alternate location passed in
          redirect = params[:location] || request.referer
          # might be an anchor tag
          redirect += params[:anchor] if params[:anchor]
          redirect_to redirect
        }
        format.json { head :no_content }
      end
    else
      raise "Not allowed"
    end
  end

  def confirmation
    reading_ids = params[:id].split('/')
    membership = Membership.find(params[:membership_id])
    challenge = membership.challenge
    @reading_confirmation_stats = ReadingConfirmationStats.new(membership, challenge, reading_ids)
  end

  def membership_reading_params
    params.permit(:reading_id, :membership_id, :challenge_id, :user_id, :challenge_name, :chapter_id, :chapter_name, :reading_ids => [])
  end

  def membership_reading
    @membership_reading ||= MembershipReading.find(params[:id])
  end

  def membership
    @membership ||= Membership.find(params[:membership_id])
  end

  def readings
    reading_ids = params[:reading_id] || params[:reading_ids]
    @readings ||= Reading.where(id: reading_ids)
    @readings
  end
end
