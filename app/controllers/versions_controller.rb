class VersionsController < ApplicationController
  
  before_filter :require_user
  
  def show
    @idea = Idea.find_by_id_and_published(params[:idea_id], true)
  
    unless @idea.nil? || params[:id].to_i > @idea.num_commits(@branch)     
      if @idea.access == Idea::PUBLIC || @idea.is_collaborator?(current_user)
        @edit = false
        @version = params[:id]
        render 'ideas/show'
      else
        flash[:error] = "You do not have access to this idea"
        redirect_to ideas_path
      end
    else
      flash[:error] = "Can't find idea or you specified a wrong version number of the idea"
      redirect_to ideas_path
    end
  end
  
end
