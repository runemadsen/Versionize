class IdeasController < ApplicationController
  
  before_filter :require_user
  
  def index
  end
  
  def show
     @idea = Idea.find params[:id]
     @repo = Repo.new @idea.repo
     @description = (@repo.commits.first.tree/'description.txt').data

     @links = @repo.commits.first.tree/Idea::FILENAME_LINKS
     unless @links.nil?
       @links = JSON.parse(@links.data)
     end
     
  end
  
  def new
    @idea = Idea.new
  end
  
  def create    
    begin
      repo_name = Idea::REPO_PATH + (Idea.count + 1).to_s + Idea::REPO_EXT
      repo = Repo.init_bare(repo_name)
      index = Index.new(repo)
      
      index.add(Idea::FILENAME_DESC, params[:description])
    
      unless params[:links] == nil
        index.add(Idea::FILENAME_LINKS, params[:links].to_json)
      end
    
      # remember to set actor user credentials in commit
      index.commit(Idea::COMMIT_MESSAGE)
    
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
    rescue Exception => e 
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_idea(@idea)
    end
    
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
      index.add(Idea::FILENAME_DESC, params[:description])
      
      unless params[:links] == nil
        index.add(Idea::FILENAME_LINKS, params[:links].to_json)
      end
      
      # remember to set actor user credentials in commit
      index.commit(Idea::COMMIT_MESSAGE, [repo.commits.first])
      flash[:notice] = "Version created!"
      redirect_to idea_url(@idea)
    rescue Exception => e 
      flash[:error] = "There was a problem! #{e}"
      redirect_to edit_idea(@idea)
    end
  end
  
  def get_link
    respond_to do |format|
      format.js
    end
  end
  
end
