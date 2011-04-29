class LinksController < ApplicationController
  
  include ApplicationHelper
  include LinksHelper
  before_filter :require_user
  before_filter :find_idea_and_branch
   
  def new
    unless @idea.nil?
      @link = Link.new
    else
      flash[:error] = "you do not have access to creating items in this idea"
      redirect_to ideas_path
    end
  end
   
  def edit
    unless @idea.nil?
      @link = @idea.file(Link::name_from_uuid(params[:id]), @branch)
    else
      flash[:error] = "you do not have access to editing items in this idea"
      redirect_to ideas_path
    end
  end
  
  def create
    
    unless @idea.nil?
      begin
        
        if params[:link][:notes] == "Notes (optional)"
          params[:link][:notes] = nil
        end
        
        @link = Link.new(params[:link])
        @link.order = @idea.next_order(@branch)
        @idea.create_version(@link, @current_user, "Added link", false, @branch)
        flash[:notice] = "Saved link"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      rescue Exception => e 
        flash[:error] = "There was a problem! #{e}"
        redirect_to new_link_branch_or_idea_path(@idea, @branch)
      end
    else
      flash[:error] = "you do not have access to creating items in this idea"
      redirect_to ideas_path
    end
  end
   
  def update
    unless @idea.nil?
      begin
        
        if params[:link][:notes] == "Notes (optional)"
          params[:link][:notes] = nil
        end
        
        @link = @idea.file(Link::name_from_uuid(params[:id]), @branch)
        @link.update(params[:link])
        @idea.create_version(@link, @current_user, "Updated link", false, @branch)
        flash[:notice] = "Saved Link"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      rescue Exception => e
        flash[:error] = "There was a problem! #{e}"
        redirect_to edit_link_branch_or_idea_path(@idea, @branch, @link)
      end
    else
      flash[:error] = "you do not have access to editing items in this idea"
      redirect_to ideas_path
    end
  end
   
  def destroy
    unless @idea.nil?
      begin
        @link = @idea.file(Link::name_from_uuid(params[:id]), @branch)
        @idea.create_version(@link, @current_user, "Deleted link", true, @branch)
        flash[:notice] = "Removed Link"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      rescue Exception => e
        flash[:error] = "There was a problem! #{e}"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      end
    else
      flash[:error] = "you do not have access to deleting items in this idea"
      redirect_to ideas_path
    end
  end
   
end