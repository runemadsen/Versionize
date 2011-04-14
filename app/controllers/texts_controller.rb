class TextsController < ApplicationController
  
  include ApplicationHelper
  include TextsHelper
  before_filter :require_user
  before_filter :find_branch

  def new
    @idea = Idea.find(params[:idea_id])
    @text = Text.new
  end
  
  def edit
    @idea = Idea.find(params[:idea_id])
    @text = @idea.file(Text::name_from_uuid(params[:id]), @branch)
  end

  def create
    begin
      @idea = Idea.find(params[:idea_id])
      @text = Text.new(:body => params[:body])
      @text.order = @idea.next_order(@branch)
      @idea.create_version(@text, @current_user, "Save text", false, @branch)
      flash[:notice] = "Saved Text"
      redirect_to idea_branch_or_master_path(@idea, @branch)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_text_branch_or_master_path(@idea, @branch)
    end
  end
  
  def update
    begin
      @idea = Idea.find(params[:idea_id])
      # no need to get the file contents here, just save the new contents to git
      @text = @idea.file(Text::name_from_uuid(params[:id]), @branch)
      @text.update(:body => params[:body])
      @idea.create_version(@text, @current_user, "Updated text", false, @branch)
      flash[:notice] = "Saved Text"
      redirect_to idea_branch_or_master_path(@idea, @branch)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to edit_text_branch_or_master_path(@idea, @branch, @text)
    end
  end
  
  def destroy
    begin
      @idea = Idea.find(params[:idea_id])
      @text = @idea.file(Text::name_from_uuid(params[:id]), @branch)
      @idea.create_version(@text, @current_user, "delete text", true, @branch)
      flash[:notice] = "Removed Text"
      redirect_to idea_branch_or_master_path(@idea, @branch)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to idea_branch_or_master_path(@idea, @branch)
    end
  end
  
end
