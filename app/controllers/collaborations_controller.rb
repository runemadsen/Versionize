class CollaborationsController < ApplicationController
  
  before_filter :require_user
  
  def index
    @idea = @current_user.ideas.find_by_id params[:idea_id]
    @collaborations = @idea.collaborations
    @users = @idea.users
  end
  
  def create
    
    user = User.find_by_email params[:email]
    
    unless user.nil?
      collaboration = user.collaborations.find_by_idea_id params[:idea_id]
      if collaboration.nil?
        begin
          idea = Idea.find params[:idea_id]
          idea.collaborations.create! :user => user
          flash[:notice] = "Collaborator succesfully added!"
        rescue Exception => e
          flash[:error] = "Something went wrong when trying to create collaboration: #{e}"
        end
      else
        flash[:error] = "This user is already a collaborator on this idea"
      end
    else
      flash[:error] = "The email adress is not registered on Versionize"
    end
    
    redirect_to idea_collaborations_path(params[:idea_id])
  end
  
  def destroy
    begin
      idea = Idea.find params[:idea_id]
      collaborator = idea.collaborations.find_by_id params[:id]
      collaborator.destroy
      flash[:notice] = "Collaborator was deleted"
    rescue Exception => e
      flash[:error] = "Something went wrong: #{e}"
    end
    
    redirect_to idea_collaborations_path(idea)
  end
  
end
