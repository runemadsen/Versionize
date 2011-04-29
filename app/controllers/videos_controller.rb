class VideosController < ApplicationController
  
  before_filter :require_user
  
  def new
    @idea = current_user.published_idea params[:idea_id]
    @branch = params[:branch_id].nil? ? @idea.branches.first : @idea.branches.find(params[:branch_id])
  end
  
end
