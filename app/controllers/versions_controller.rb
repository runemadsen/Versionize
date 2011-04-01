class VersionsController < ApplicationController
  
  def show
    @idea = current_user.published_idea params[:idea_id]
    @branch = params[:branch_id]
    unless @idea.nil?      
      if(params[:id].to_i <= @idea.num_commits)
        @edit = false
        @version = params[:id]
        render 'ideas/show'
      else
        flash[:error] = "Can't find version number #{@version}"
        redirect_to idea_path(@idea)
      end
    else
      flash[:error] = "You do not have access to this idea"
      redirect_to ideas_path
    end
  end
  
end
