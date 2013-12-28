class MembershipReadingsController < ApplicationController

  before_filter :authenticate_user!, only: [:update]
  before_filter :find_membership_reading, except: [:update, :edit]

  layout 'from_email'

  def update
    @comment = Comment.new
    @user = current_user
    @membership_reading = current_user.membership_readings.find_by_id(params[:id])
    @membership = @membership_reading.membership
    @reading = @membership_reading.reading
    #just going to toggle state on any update
    @membership_reading.state = (@membership_reading.state == 'unread') ? 'read' : 'unread'
    @membership_reading.save!
    #render action: :edit 
    redirect_to params[:location] || request.referer
  end

  def edit
    @comment = Comment.new
    hashids = HashidsGenerator.instance
    membership_reading_id = hashids.decrypt(params[:id])
    @membership_reading = MembershipReading.find_by_id(membership_reading_id)
    if @membership_reading
      @user = @membership_reading.membership.user
      sign_in @user
      @reading = @membership_reading.reading
    else
      flash[:error] = "This confirmation link doesn't exist"
    end
  end


  def confirm
    @comment = Comment.new
    if @membership_reading
      @hash = params[:hash]
      @user = @membership_reading.membership.user
      sign_in @user
      @reading = @membership_reading.reading
    else
      flash[:error] = "This confirmation link doesn't exist"
    end
  end

  def log
    @membership = @membership_reading.membership
    @reading = @membership_reading.reading

    @membership_reading.state = 'read'
    @membership_reading.save!
  end

  private

  def find_membership_reading
    hashids = HashidsGenerator.instance
    membership_reading_id = hashids.decrypt(params[:hash])
    @membership_reading = MembershipReading.find_by_id(membership_reading_id)
  end

end
