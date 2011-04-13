module LinksHelper
  
  def new_link_branch_or_master_path idea, branch
    branch == "master" || branch.nil? ? new_idea_link_path(idea) : new_idea_branch_link_path(idea, branch)
  end
  
  def edit_link_branch_or_master_path idea, branch, link
    branch == "master" || branch.nil? ? edit_idea_link_path(idea) : edit_idea_branch_link_path(idea, branch, link)
  end
  
end
