module ApplicationHelper
  
  def find_idea_and_version_by_params
    @idea = current_user.published_idea params[:idea_id]
    raise Exception, "You do not have access to this idea, or it doesn't exist" if @idea.nil?
    @version = @idea.versions.find_by_alias(params[:version_id])
    raise Exception, "You have specified a wrong version" if @version.nil?
  end
  
  def find_idea_and_version_by_id
    @idea = current_user.published_idea params[:idea_id]
    raise Exception, "You do not have access to this idea, or it doesn't exist" if @idea.nil?
    @version = @idea.versions.find_by_alias(params[:id])
    raise Exception, "You have specified a wrong version" if @version.nil?
  end
  
  def version_or_idea_path idea, version
    version.alias == "master" ? idea_path(idea) : idea_version_path(idea, version.alias)
  end
   
end
