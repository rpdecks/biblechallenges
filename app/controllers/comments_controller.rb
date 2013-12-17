class CommentsController < ApplicationController

  before_filter :authenticate_user!, only: [:create]

  def create
  end
end
