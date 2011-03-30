class IdeasController < ApplicationController
  
  before_filter :require_user_no_notice
  
  def index
  end
  
  def show
    @idea = Idea.find params[:id]
     
    if @idea.user == @current_user
      @version = 0
      @edit = true   
    else
      flash[:error] = "You do not have access to this idea"
      redirect_to ideas_path
    end
  end
  
  def show_version
    @idea = Idea.find params[:id]
    
    if @idea.user == @current_user
      if(params[:version_id].to_i <= @idea.num_commits)
        @version = params[:version_id]
        render :show
      else
        flash[:error] = "Can't find version number #{@version}"
        redirect_to idea_path(@idea)
      end
    else
      flash[:error] = "You do not have access to this idea"
      redirect_to ideas_path
    end
  end
  
  def new
    @idea = Idea.new
  end
  
  def create    
    begin
      @idea = Idea.new params[:idea]
      @text = Text.new(:body => params[:description])
      @idea.create_repo(@text, @current_user, "Save initial details")
      @idea.save
      flash[:notice] = "Idea Saved!"
      redirect_to idea_url(@idea)
    rescue Exception => e 
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_idea_path(@idea)
    end
    
  end
  
end
