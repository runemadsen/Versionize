class BranchesController < ApplicationController
  
  def show
    
    @idea = current_user.published_idea params[:idea_id]
    @version = 0
    @branch = params[:id]
    
    unless @idea.nil?
      @edit = true
      render 'ideas/show'
    else
      flash[:error] = "You do not have access to this idea"
      redirect_to ideas_path
    end
  end
  
end
