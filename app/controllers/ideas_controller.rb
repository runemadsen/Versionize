class IdeasController < ApplicationController
  
  require 'grit'
  include Grit
  
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
    
    repo_name = 'repos/repo' + (Idea.count + 1).to_s + '.git'
    repo = Repo.init_bare(repo_name)
    
    @idea = Idea.new(params[:idea])
    @idea.repo = repo_name
    @idea.user = @current_user
    
    if @idea.save
      flash[:notice] = "Idea Saved!"
      redirect_to idea_url(@idea)
    else
      flash[:notice] = "Something went wrong"
      render :action => :new
    end
  end
  
end
