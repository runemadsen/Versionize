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
      index = repo.index
      index.read_tree('master')
      index.add('mytext.txt', params[:text])
      # remember to set actor user credentials in commit
      index.commit('Text commit', [repo.commits.first])
      flash[:notice] = "Version created!"
    rescue Exception => e 
      flash[:error] = "There was a problem! #{e}"
    end
    
    redirect_to idea_url(@idea)

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
  
  def get_link
    respond_to do |format|
      format.js
    end
  end
  
end
