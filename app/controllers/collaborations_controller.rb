class CollaborationsController < ApplicationController
  
  before_filter :require_user
  
  def index
    @idea = @current_user.ideas.find_by_id params[:idea_id]
    @collaborations = @idea.collaborations
    @users = @idea.users
  end
  
end
