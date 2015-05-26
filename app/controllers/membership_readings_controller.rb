class MembershipReadingsController < ApplicationController

  before_filter :authenticate_user!, only: [:update]

  acts_as_token_authentication_handler_for User, only: [:edit]

  layout 'from_email'

  def create
    MembershipReading.create(membership_reading_params)
    redirect_to [:member, membership]
  end

  def update
    @comment = Comment.new
    @user = current_user
    @membership_reading = current_user.membership_readings.find_by_id(params[:id])
    @membership = @membership_reading.membership
    @reading = @membership_reading.reading
    #just going to toggle state on any update
    @membership_reading.state = (@membership_reading.state == 'unread') ? 'read' : 'unread'
    @membership_reading.save!

    if @membership_reading.state == 'read'
      notice = "Reading updated!  You have completed #{@reading.chapter.book_and_chapter}."
    else
      notice = "Reading updated!"
    end

    redirect_to params[:location] || request.referer, notice: notice
  end

  def edit
    @comment = Comment.new
    if membership_reading
      @user = membership_reading.membership.user
      sign_in @user
      @reading = membership_reading.reading
    else
      flash[:error] = "This confirmation link doesn't exist or you may have unsubscribed from this challenge"
    end
  end


  def confirm
    @comment = Comment.new
    if membership_reading
      @user = membership_reading.membership.user
      sign_in @user
      @reading = membership_reading.reading
    else
      flash[:error] = "This confirmation link doesn't exist"
    end
  end

  def log
    @membership = membership_reading.membership
    @reading = membership_reading.reading

    membership_reading.state = 'read'
    membership_reading.save!
  end

  private

  def membership_reading_params
    params.permit(:reading_id, :membership_id)
  end

  def membership_reading
    @membership_reading ||= MembershipReading.find(params[:id])
  end

  def membership
    @membership ||= Membership.find(params[:membership_id])
  end

end
