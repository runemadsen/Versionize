class LinksController < ApplicationController
  
  include ApplicationHelper
  before_filter :require_user
  before_filter :find_branch
   
  def new
    @idea = Idea.find(params[:idea_id])
    @link = Link.new
  end
   
  def edit
    @idea = Idea.find(params[:idea_id])
    @link = @idea.file(Link::name_from_uuid(params[:id]))
  end
  
  def create
    begin
      @idea = Idea.find(params[:idea_id])
      @link = Link.new params[:link]
      @link.order = @idea.next_order(@branch)
      @idea.create_version(@link, @current_user, "Save link", false, @branch)
      flash[:notice] = "Saved link"
      redirect_to idea_branch_or_master_path(@idea, @branch)
    rescue Exception => e 
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_link_idea_branch_or_master_path(@idea, @branch)
    end  
  end
   
  def update
    begin
      @idea = Idea.find(params[:idea_id])
      @link = @idea.file(Link::name_from_uuid(params[:id]), @branch)
      @link.update(params[:link])
      @idea.create_version(@link, @current_user, "Updated link", false, @branch)
      flash[:notice] = "Saved Link"
      redirect_to idea_branch_or_master_path(@idea)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to edit_link_branch_or_master_path(@idea, @branch, @text)
    end
  end
   
  def destroy
    begin
      @idea = Idea.find(params[:idea_id])
      @link = @idea.file(Link::name_from_uuid(params[:id]), @branch)
      @idea.create_version(@link, @current_user, "delete link", true, @branch)
      flash[:notice] = "Removed Link"
      redirect_to idea_branch_or_master_path(@idea, @branch)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to idea_branch_or_master_path(@idea, @branch)
    end
  end
   
end