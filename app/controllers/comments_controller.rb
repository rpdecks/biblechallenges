class CommentsController < ApplicationController
	respond_to :json
  before_action :authenticate_user

	def create
		@comment = current_user.comments.new(comment_params)
		if @comment.save
			render json: {id: @comment.id}
		else
			raise "cannot save comment"
	end
	end

	def destroy
    if (@comment = current_user.comments.find_by_id(params[:id]))
      @comment.destroy
      head :no_content
    else
    	head :unauthorized
    end
	end

	private

	def authenticate_user
	  unless current_user
	    head :unauthorized
	  end
	end

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end
end