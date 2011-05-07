module ApplicationHelper
  
  def find_idea_and_version_by_params(idea_id, version_id, throw_exception = true)
    @idea = Idea.includes([:collaborations]).find_by_id_and_published(params[:idea_id], true)
    if(throw_exception && !@idea.is_collaborator?(current_user))
      raise Exception, "You do not have access to this idea, or it doesn't exist" 
    end
    @version = @idea.versions.find_by_alias(version_id)
    raise Exception, "You have specified a wrong version" if @version.nil?
  end
  
  def version_or_idea_path idea, version
    version.alias == "master" ? idea_path(idea) : idea_version_path(idea, version.alias)
  end
   
end
