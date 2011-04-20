class BranchesController < ApplicationController
  
  before_filter :require_user
  
  def show
    
    @idea = Idea.where(:id => params[:idea_id], :published => true)
    unless @idea.nil?
      @version = 0
      @branch = params[:id]
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
    else
      flash[:error] = "Can't find idea"
      redirect_to ideas_path
    end
    
  end
  
  def new 
    @idea_id = params[:idea_id]
  end
  
  def create
    @idea = Idea.find(params[:idea_id])
    @branch = params[:branch_name].downcase.gsub(" ", "")
    @idea.create_branch("master", @branch, current_user)
    redirect_to idea_branch_path(@idea, @branch)
  end
  
end
