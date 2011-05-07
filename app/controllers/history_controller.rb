class HistoryController < ApplicationController
  
  include ApplicationHelper
  include HistoryHelper
  before_filter :require_user
  
  def show
    begin
      find_idea_and_version_by_params(params[:idea_id], params[:version_id], false)
      @tree = @idea.files(params[:id])
      
      if @idea.public? || @idea.is_collaborator?(current_user)
        @edit = false
        render 'ideas/show'
      else
        flash[:error] = "You do not have access to this idea"
        redirect_to ideas_path
      end
      
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
end
