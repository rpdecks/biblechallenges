class MembershipReadingsController < ApplicationController
  respond_to :html, :json
  acts_as_token_authentication_handler_for User, only: [:create]
  before_filter :authenticate_user!, except: [:confirmation] # needs to follow token_authentication_handler

  layout 'from_email'

  def create
    @challenge = membership.challenge

    if @challenge.has_member?(current_user) && membership.user == current_user

      readings.each do |reading|
      # we want to create a membership reading for each reading so I'm merging the reading params in
        @membership_reading = MembershipReading.create(membership_reading_params.merge(reading_id: reading.id))
      end

      if @membership_reading.save
        update_stats
      end

      respond_to do |format|
        format.html {
          # go back to referer unless alternate location passed in
          redirect = params[:location] || request.referer
          # might be an anchor tag
          redirect += params[:anchor] if params[:anchor]
          redirect_to redirect
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
    @slug = Membership.find(params[:membership_id]).challenge.slug
  end

  def membership_reading_params
    params.permit(:reading_id, :membership_id)
  end

  def membership_reading
    @membership_reading ||= MembershipReading.find(params[:id])
  end

  def membership
    @membership ||= Membership.find(params[:membership_id])
  end

  def readings
    @readings ||= Reading.find(params[:reading_id])
    @readings = [@readings] unless @readings.is_a? Array
    @readings
  end
end
