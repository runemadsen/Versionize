class TextsController < ApplicationController
  
  include ApplicationHelper
  include TextsHelper
  before_filter :require_user

  def new
    begin
      find_idea_and_version_by_params
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def edit
    begin
      find_idea_and_version_by_params
      @text = @idea.file(Text::name_from_uuid(params[:id]), @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end

  def create
    begin
      find_idea_and_version_by_params
      @text = Text.new(:body => params[:body])
      @text.order = @idea.next_order(@version)
      @idea.create_history(@text, @current_user, "Added text", @version)
      flash[:notice] = "Saved Text"
      redirect_to version_or_idea_path(@idea, @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def update
    begin
      find_idea_and_version_by_params
      @text = @idea.file(Text::name_from_uuid(params[:id]), @version)
      @text.update(:body => params[:body])
      @idea.create_history(@text, @current_user, "Updated text", @version)
      flash[:notice] = "Saved Text"
      redirect_to version_or_idea_path(@idea, @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def destroy
    begin
      find_idea_and_version_by_params
      @text = @idea.file(Text::name_from_uuid(params[:id]), @version)
      @idea.create_history(@text, @current_user, "Deleted text", @version, true)
      flash[:notice] = "Deleted Text"
      redirect_to version_or_idea_path(@idea, @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
end
