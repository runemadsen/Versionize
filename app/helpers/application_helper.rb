module ApplicationHelper
  
  def find_branch
    @branch = params[:branch_id] ? params[:branch_id] : "master"
  end
  
  def idea_branch_or_master_path idea, branch
    branch == "master" ? idea_path(idea) : idea_branch_path(idea, branch)
  end
  
end
