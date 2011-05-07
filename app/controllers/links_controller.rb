class LinksController < ApplicationController
  
  include ApplicationHelper
  include LinksHelper
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
      @link = @idea.file(Link::name_from_uuid(params[:id]), @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def create
    begin
      find_idea_and_version_by_params
      params[:link][:notes] = params[:link][:notes] == "Notes (optional)" ? nil : params[:link][:notes]
      @link = Link.new(params[:link])
      @link.order = @idea.next_order(@version)
      @idea.create_history(@link, @current_user, "Added link", @version)
      flash[:notice] = "Saved link"
      redirect_to version_or_idea_path(@idea, @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def update
    begin
      find_idea_and_version_by_params
      params[:link][:notes] = params[:link][:notes] == "Notes (optional)" ? nil : params[:link][:notes]
      @link = @idea.file(Link::name_from_uuid(params[:id]), @version)
      @link.update(params[:link])
      @idea.create_history(@link, @current_user, "Updated link", @version)
      flash[:notice] = "Saved Link"
      redirect_to version_or_idea_path(@idea, @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def destroy
    begin
      find_idea_and_version_by_params
      @link = @idea.file(Link::name_from_uuid(params[:id]), @version)
      @idea.create_history(@link, @current_user, "Deleted link", @version, true)
      flash[:notice] = "Deleted Link"
      redirect_to version_or_idea_path(@idea, @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
   
end