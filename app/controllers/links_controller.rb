class LinksController < ApplicationController
  
  include ApplicationHelper
  include LinksHelper
  before_filter :require_user
   
  def new
    begin
      find_idea_and_branch_by_params
      @link = Link.new
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
   
  def edit
    begin
      find_idea_and_branch_by_params
      @link = @idea.file(Link::name_from_uuid(params[:id]), @branch.alias)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def create
    begin
      find_idea_and_branch_by_params
      params[:link][:notes] = params[:link][:notes] == "Notes (optional)" ? nil : params[:link][:notes]
      @link = Link.new(params[:link])
      @link.order = @idea.next_order(@branch.alias)
      @idea.create_version(@link, @current_user, "Added link", false, @branch.alias)
      flash[:notice] = "Saved link"
      redirect_to branch_or_idea_path(@idea, @branch_num)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def update
    begin
      find_idea_and_branch_by_params
      params[:link][:notes] = params[:link][:notes] == "Notes (optional)" ? nil : params[:link][:notes]
      @link = @idea.file(Link::name_from_uuid(params[:id]), @branch.alias)
      @link.update(params[:link])
      @idea.create_version(@link, @current_user, "Updated link", false, @branch.alias)
      flash[:notice] = "Saved Link"
      redirect_to branch_or_idea_path(@idea, @branch_num)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def destroy
    begin
      find_idea_and_branch_by_params
      @link = @idea.file(Link::name_from_uuid(params[:id]), @branch.alias)
      @idea.create_version(@link, @current_user, "Deleted link", true, @branch.alias)
      flash[:notice] = "Deleted Link"
      redirect_to branch_or_idea_path(@idea, @branch_num)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
   
end