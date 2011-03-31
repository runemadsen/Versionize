class IdeasController < ApplicationController
  
  before_filter :require_user_no_notice
  
  def index
    @ideas = @current_user.published_ideas
    #@ideas = @current_user.published_ideas
  end
  
  def show
    @idea = @current_user.ideas.find_by_id params[:id]
     
    unless @idea.nil?
      @version = 0
      @edit = true   
    else
      flash[:error] = "You do not have access to this idea"
      redirect_to ideas_path
    end
  end
  
  def show_version
    
    @idea = @current_user.ideas.find_by_id params[:id]
    
    unless @idea.nil?
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
      @collaboration = Collaboration.create! :user => @current_user, :idea => @idea, :owner => true
      flash[:notice] = "Idea Saved!"
      redirect_to idea_url(@idea)
    rescue Exception => e 
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_idea_path
    end
  end
  
  def destroy
    begin      
      @idea = @current_user.published_idea params[:id]
      @idea.published = false
      @idea.save
      flash[:notice] = "Your idea was deleted"
      redirect_to ideas_path
    rescue Exception => e
      flash[:error] = "Something went wrong: #{e}"
      redirect_to idea_path(@idea)
    end
  end
  
end
