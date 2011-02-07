class IdeasController < ApplicationController
  
  before_filter :require_user
  
  def index
  end
  
  def show
     @idea = Idea.find params[:id]
  end
  
  def new
    @idea = Idea.new(:user => @current_user)
  end
  
  def create
    @idea = Idea.new(params[:idea])
    if @idea.save
      flash[:notice] = "Idea Saved!"
      redirect_to idea_url(@idea)
    else
      flash[:notice] = "Something went wrong"
      render :action => :new
    end
  end
  
end
