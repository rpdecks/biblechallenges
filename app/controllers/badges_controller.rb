class BadgesController < ApplicationController

  def index
    @badge_classes = Badge.descendants
  end

  def show
    @badge_class = params[:id].constantize
    @badge = @badge_class.new
    @users = @badge_class.earned
  end
end
