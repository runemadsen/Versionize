module ApplicationHelper
  
  def find_idea_and_branch_by_params
    @idea = current_user.published_idea params[:idea_id]
    @branch = @idea.branches[params[:branch_id].to_i - 1]
    @branch_num = params[:branch_id].to_i
    raise Exception, "You do not have access to this idea, or it doesn't exist" if @idea.nil?
    raise Exception, "You have specified a wrong branch" if @branch.nil?
  end
  
  def branch_or_idea_path idea, branch_num
    branch_num == 1 ? idea_path(idea) : idea_branch_path(idea, branch_num)
  end
   
end
