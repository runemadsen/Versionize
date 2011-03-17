class TextsController < ApplicationController
  
  before_filter :require_user

  def new
   @idea = Idea.find(params[:idea_id])
   @text = Text.new
  end

  def create
    begin
      text = Text.new params[:text]
      @idea = Idea.find(params[:idea_id])
      @idea.create_version(text, @current_user, "Save text")
      flash[:notice] = "Saved link"
      redirect_to idea_path(@idea)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_idea_text_path(@idea)
    end
  end
  
end
