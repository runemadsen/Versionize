class IdeasController < ApplicationController
  
  before_filter :require_user
  
  def index
  end
  
  def show
     @idea = Idea.find params[:id]
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
