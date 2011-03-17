class TextsController < ApplicationController
  
  before_filter :require_user

  def new
   @idea = Idea.find(params[:idea_id])
   @text = Text.new
  end

  def create
    begin
      text = Text.new params[:text]
      idea = Idea.find(params[:idea_id])
      @repo = Repo.new(idea.repo)
      index = @repo.index
      index.read_tree('master')
      index.add(text.generate_name, text.to_json)
      index.commit("Added text", [@repo.commits.first], Actor.new("Versionize User", @current_user.email))
      redirect_to idea_path(idea)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_idea_text_path(@idea)
    end
  end
  
end
