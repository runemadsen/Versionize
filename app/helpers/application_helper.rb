module ApplicationHelper
  
  def find_idea_and_branch_by_params
    @idea = current_user.published_idea params[:idea_id]
    raise Exception, "You do not have access to this idea, or it doesn't exist" if @idea.nil?
    @branch = @idea.branches.find_by_alias(params[:branch_id])
    raise Exception, "You have specified a wrong branch" if @branch.nil?
  end
  
  def find_idea_and_branch_by_id
    @idea = current_user.published_idea params[:idea_id]
    raise Exception, "You do not have access to this idea, or it doesn't exist" if @idea.nil?
    @branch = @idea.branches.find_by_alias(params[:id])
    raise Exception, "You have specified a wrong branch" if @branch.nil?
  end
  
  def branch_or_idea_path idea, branch
    branch.alias == "master" ? idea_path(idea) : idea_branch_path(idea, branch.alias)
  end
   
end
