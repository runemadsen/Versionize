class BranchesController < ApplicationController
  
  before_filter :require_user
  
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
  
  def new 
    @idea_id = params[:idea_id]
  end
  
  def create
    @idea = Idea.find(params[:idea_id])
    @branch = params[:branch_name].downcase.gsub!(" ", "")
    @idea.create_branch("master", @branch, current_user)
    redirect_to idea_branch_path(@idea, @branch)
  end
  
end
