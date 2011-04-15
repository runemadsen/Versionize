class LinksController < ApplicationController
  
  include ApplicationHelper
  include LinksHelper
  before_filter :require_user
  before_filter :find_branch
   
  def new
    @idea = current_user.published_idea params[:idea_id]
    unless @idea.nil?
      @link = Link.new
    else
      flash[:error] = "you do not have access to creating items in this idea"
      redirect_to ideas_path
    end
  end
   
  def edit
    @idea = current_user.published_idea params[:idea_id]
    unless @idea.nil?
      @link = @idea.file(Link::name_from_uuid(params[:id]), @branch)
    else
      flash[:error] = "you do not have access to editing items in this idea"
      redirect_to ideas_path
    end
  end
  
  def create
    
    @idea = current_user.published_idea params[:idea_id]
    
    unless @idea.nil?
      begin
        @link = Link.new(:url => params[:url])
        @link.order = @idea.next_order(@branch)
        @idea.create_version(@link, @current_user, "Save link", false, @branch)
        flash[:notice] = "Saved link"
        redirect_to idea_branch_or_master_path(@idea, @branch)
      rescue Exception => e 
        flash[:error] = "There was a problem! #{e}"
        redirect_to new_link_branch_or_master_path(@idea, @branch)
      end
    else
      flash[:error] = "you do not have access to creating items in this idea"
      redirect_to ideas_path
    end
  end
   
  def update
    
    @idea = current_user.published_idea params[:idea_id]
    
    unless @idea.nil?
      begin
        @link = @idea.file(Link::name_from_uuid(params[:id]), @branch)
        @link.update(:url => params[:url])
        @idea.create_version(@link, @current_user, "Updated link", false, @branch)
        flash[:notice] = "Saved Link"
        redirect_to idea_branch_or_master_path(@idea, @branch)
      rescue Exception => e
        flash[:error] = "There was a problem! #{e}"
        redirect_to edit_link_branch_or_master_path(@idea, @branch, @link)
      end
    else
      flash[:error] = "you do not have access to editing items in this idea"
      redirect_to ideas_path
    end
  end
   
  def destroy
    @idea = current_user.published_idea params[:idea_id]
    
    unless @idea.nil?
      begin
        @link = @idea.file(Link::name_from_uuid(params[:id]), @branch)
        @idea.create_version(@link, @current_user, "delete link", true, @branch)
        flash[:notice] = "Removed Link"
        redirect_to idea_branch_or_master_path(@idea, @branch)
      rescue Exception => e
        flash[:error] = "There was a problem! #{e}"
        redirect_to idea_branch_or_master_path(@idea, @branch)
      end
    else
      flash[:error] = "you do not have access to deleting items in this idea"
      redirect_to ideas_path
    end
  end
   
end