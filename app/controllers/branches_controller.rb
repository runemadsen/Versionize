class BranchesController < ApplicationController
  
  include ApplicationHelper
  before_filter :require_user
  
  def show
    begin
      find_idea_and_branch_by_id
      @version = 0
      @tree = @idea.files(@branch.alias)
    rescue Exception => e
      puts e
      flash[:error] = e.message
      redirect_to ideas_path
      return
    end
    
    if @idea.is_collaborator?(current_user)
      @edit = true
      render 'ideas/show'
    elsif @idea.access == Idea::PUBLIC
      @edit = false
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
    @idea.create_branch("master", params[:branch_name], current_user)
    redirect_to idea_branch_path(@idea, @idea.branches.last.alias)
  end
  
end
