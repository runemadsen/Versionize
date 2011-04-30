class TextsController < ApplicationController
  
  include ApplicationHelper
  include TextsHelper
  before_filter :require_user

  def new
    begin
      find_idea_and_branch_by_params
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def edit
    begin
      find_idea_and_branch_by_params
      @text = @idea.file(Text::name_from_uuid(params[:id]), @branch)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end

  def create
    begin
      find_idea_and_branch_by_params
      @text = Text.new(:body => params[:body])
      @text.order = @idea.next_order(@branch)
      @idea.create_version(@text, @current_user, "Added text", @branch)
      flash[:notice] = "Saved Text"
      redirect_to branch_or_idea_path(@idea, @branch)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def update
    begin
      find_idea_and_branch_by_params
      @text = @idea.file(Text::name_from_uuid(params[:id]), @branch)
      @text.update(:body => params[:body])
      @idea.create_version(@text, @current_user, "Updated text", @branch)
      flash[:notice] = "Saved Text"
      redirect_to branch_or_idea_path(@idea, @branch)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def destroy
    begin
      find_idea_and_branch_by_params
      @text = @idea.file(Text::name_from_uuid(params[:id]), @branch)
      @idea.create_version(@text, @current_user, "Deleted text", @branch, true)
      flash[:notice] = "Deleted Text"
      redirect_to branch_or_idea_path(@idea, @branch)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
end
