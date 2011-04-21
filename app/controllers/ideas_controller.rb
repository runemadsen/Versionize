class IdeasController < ApplicationController
  
  before_filter :require_user_no_notice
  
  def index
    @ideas = current_user.published_ideas
  end
  
  def show
    @idea = Idea.where(:id => params[:id], :published => true).first
    unless @idea.nil?
      @version = 0
      if @idea.is_collaborator?(current_user)
        @edit = true
      elsif @idea.access == Idea::PUBLIC
        @edit = false
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
    @idea = Idea.new
  end
  
  def create    
    begin
      @idea = Idea.new params[:idea]
      @text = Text.new(:body => params[:description])
      @text.order = 9999999999
      @idea.create_repo
      @idea.create_version(@text, current_user, "Save initial details")
      @idea.save
      @collaboration = Collaboration.create! :user => current_user, :idea => @idea, :owner => true
      flash[:notice] = "Idea Saved!"
      redirect_to idea_url(@idea)
    rescue Exception => e 
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_idea_path
    end
  end
  
  def destroy
    begin      
      @idea = current_user.published_idea params[:id]
      @idea.published = false
      @idea.save
      flash[:notice] = "Your idea was deleted"
      redirect_to ideas_path
    rescue Exception => e
      flash[:error] = "Something went wrong: #{e}"
      redirect_to idea_path(@idea)
    end
  end
  
  def toggle_access
    @idea = current_user.published_idea params[:id]
    
    unless @idea.nil?
      @idea.access = @idea.access == Idea::PUBLIC ? Idea::PRIVATE : Idea::PUBLIC
      @idea.save  
    else
      raise Exception, "Idea does not belong to you"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
end
