class TextsController < ApplicationController
  
  before_filter :require_user
  include ApplicationHelper

  def new
   @idea = Idea.find(params[:idea_id])
   @text = Text.new
  end
  
  def edit
    @idea = Idea.find(params[:idea_id])
    @text = @idea.file(Text::name_from_uuid(params[:id]))
  end

  def create
    begin
      @idea = Idea.find(params[:idea_id])
      @text = Text.new params[:text]
      @text.order = @idea.next_order
      @idea.create_version(@text, @current_user, "Save text", false, params[:branch_id].nil? ? "master" : params[:branch_id])
      flash[:notice] = "Saved Text"
      redirect_to idea_branch_or_master_path(@idea, params)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_idea_branch_or_master_path(@idea, params)
    end
  end
  
  def update
    begin
      @idea = Idea.find(params[:idea_id])
      @text = @idea.file(Text::name_from_uuid(params[:id]))
      @text.update(params[:text])
      @idea.create_version(@text, @current_user, "Updated text")
      flash[:notice] = "Saved Text"
      redirect_to idea_path(@idea)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_idea_text_path(@idea)
    end
  end
  
  def destroy
    begin
      @idea = Idea.find(params[:idea_id])
      @text = @idea.file(Text::name_from_uuid(params[:id]))
      @idea.create_version(@text, @current_user, "delete text", true)
      flash[:notice] = "Removed Text"
      redirect_to idea_path(@idea)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to idea_path(@idea)
    end
  end
  
end
