class VersionsController < ApplicationController
  
  include ApplicationHelper
  before_filter :require_user
  
  def show
    begin
      find_idea_and_version_by_params(params[:idea_id], params[:id], false)
      @history = 0
      @tree = @idea.files(@version.alias)
      
      if @idea.is_collaborator?(current_user)
        @edit = true
        render 'ideas/show'
      elsif @idea.public?
        @edit = false
        render 'ideas/show'
      else
        flash[:error] = "You do not have access to this idea"
        redirect_to ideas_path
      end
      
    rescue Exception => e
      puts e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def new 
    @idea_id = params[:idea_id]
  end
  
  def create
    @idea = Idea.find(params[:idea_id])
    @idea.create_version("master", params[:version_name], current_user)
    redirect_to idea_version_path(@idea, @idea.versions.last.alias)
  end
  
end
