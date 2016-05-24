class ReactCommentsController < ApplicationController
	respond_to :json
  before_action :authenticate_user
	before_action :validate_create_permission, only: [:create]

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

	def validate_create_permission
		commentable_type = params[:comment][:commentable_type]
		commentable_id = params[:comment][:commentable_id]

		permitted = case commentable_type
			when "Challenge"
				Challenge.find(commentable_id.to_i).has_member?(current_user)
			when "Reading"
				Reading.find(commentable_id).challenge.has_member?(current_user)
			when "Group"
				Group.find(commentable_id).has_member?(current_user)
			else
				false
		end

		head :unauthorized if not permitted
	end

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end
end