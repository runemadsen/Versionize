class IdeasController < ApplicationController
  
  before_filter :require_user
  
  def index
  end
  
  def show
     @idea = Idea.find params[:id]
     @idea.load_repo
  end
  
  def new
    @idea = Idea.new
  end
  
  def create    
    
    begin
      repo_name = Idea::REPO_PATH + (Idea.count + 1).to_s + Idea::REPO_EXT
      @repo = Repo.init_bare(repo_name)
      index = Index.new(@repo)
      text = Text.new(:body => params[:description])
      index.add(text.generate_name, text.to_json)
      index.commit("Created idea", nil, Actor.new("Versionize User", @current_user.email))
    
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
      redirect_to new_idea_path(@idea)
    end
    
  end
  
end
