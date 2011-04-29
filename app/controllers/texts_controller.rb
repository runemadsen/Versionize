class TextsController < ApplicationController
  
  include ApplicationHelper
  include TextsHelper
  before_filter :require_user
  before_filter :find_idea_and_branch

  def new
    unless @idea.nil?
      @text = Text.new
    else
      flash[:error] = "you do not have access to creating items in this idea"
      redirect_to ideas_path
    end
  end
  
  def edit
    unless @idea.nil?
      @text = @idea.file(Text::name_from_uuid(params[:id]), @branch.alias)
    else
      flash[:error] = "you do not have access to editing items in this idea"
      redirect_to ideas_path
    end
  end

  def create
    unless @idea.nil?
      begin
        @text = Text.new(:body => params[:body])
        @text.order = @idea.next_order(@branch)
        @idea.create_version(@text, @current_user, "Added text", false, @branch)
        flash[:notice] = "Saved Text"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      rescue Exception => e
        puts 'Error is ' + e
        flash[:error] = "There was a problem! #{e}"
        redirect_to new_text_branch_or_idea_path(@idea, @branch)
      end
    else
      flash[:error] = "you do not have access to creating items in this idea"
      redirect_to ideas_path
    end
  end
  
  def update
    unless @idea.nil?
      begin
        # no need to get the file contents here, just save the new contents to git
        @text = @idea.file(Text::name_from_uuid(params[:id]), @branch)
        @text.update(:body => params[:body])
        @idea.create_version(@text, @current_user, "Updated text", false, @branch)
        flash[:notice] = "Saved Text"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      rescue Exception => e
        flash[:error] = "There was a problem! #{e}"
        redirect_to edit_text_branch_or_idea_path(@idea, @branch, @text)
      end
    else
      flash[:error] = "you do not have access to editing items in this idea"
      redirect_to ideas_path
    end
  end
  
  def destroy
    unless @idea.nil?
      begin
        @text = @idea.file(Text::name_from_uuid(params[:id]), @branch)
        @idea.create_version(@text, @current_user, "Deleted text", true, @branch)
        flash[:notice] = "Removed Text"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      rescue Exception => e
        flash[:error] = "There was a problem! #{e}"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      end
    else
      flash[:error] = "you do not have access to editing items in this idea"
      redirect_to ideas_path
    end
  end
  
end
