class TextsController < ApplicationController
  
  include ApplicationHelper
  include TextsHelper
  before_filter :require_user

  def new
    begin
      find_idea_and_branch_by_params
      @text = Text.new
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def edit
    begin
      find_idea_and_branch_by_params
      @text = @idea.file(Text::name_from_uuid(params[:id]), @branch.alias)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end

  def create
    begin
      find_idea_and_branch_by_params
      @text = Text.new(:body => params[:body])
      @text.order = @idea.next_order(@branch.alias)
      @idea.create_version(@text, @current_user, "Added text", false, @branch.alias)
      flash[:notice] = "Saved Text"
      redirect_to branch_or_idea_path(@idea, @branch_num)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def update
    begin
      find_idea_and_branch_by_params
      @text = @idea.file(Text::name_from_uuid(params[:id]), @branch.alias)
      @text.update(:body => params[:body])
      @idea.create_version(@text, @current_user, "Updated text", false, @branch.alias)
      flash[:notice] = "Saved Text"
      redirect_to branch_or_idea_path(@idea, @branch_num)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def destroy
    begin
      find_idea_and_branch_by_params
      @text = @idea.file(Text::name_from_uuid(params[:id]), @branch.alias)
      @idea.create_version(@text, @current_user, "Deleted text", true, @branch.alias)
      flash[:notice] = "Deleted Text"
      redirect_to branch_or_idea_path(@idea, @branch_num)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
end
