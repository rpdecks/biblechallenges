class MembershipsController < ApplicationController

  def index
    @memberships = current_user.memberships
  end
end
