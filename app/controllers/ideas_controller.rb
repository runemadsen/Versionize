class IdeasController < ApplicationController
  
  require 'grit'
  include Grit
  
  before_filter :require_user
  
  def index
  end
  
  def show
     @idea = Idea.find params[:id]
     @repo = Repo.new @idea.repo
  end
  
  def new
    @idea = Idea.new
  end
  
  def edit
    @idea = Idea.find params[:id]
    @repo = Repo.new @idea.repo
  end
  
  def update
    
    begin
      idea = Idea.find(params[:id])
      repo = Repo.new(idea.repo)
      index = Index.new(repo)
      index.add('mytext.txt', params[:text])
      # remember to set actor user credentials in commit
      index.commit('Text commit')
    
      flash[:notice] = "Version created!"
      redirect_to idea_url(@idea)
    rescue
      flash[:error] = "There was a problem!"
      redirect_to idea_url(@idea)
    end

  end
  
  def create
    
    repo_name = 'repos/repo' + (Idea.count + 1).to_s + '.git'
    repo = Repo.init_bare(repo_name)
    index = Index.new(repo)
    index.add('mytext.txt', params[:text])
    # remember to set actor user credentials in commit
    index.commit('Text commit')
    
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
