module TextsHelper
  
  def new_text_branch_or_master_path idea, branch
    branch == "master" || branch.nil? ? new_idea_text_path(idea) : new_idea_branch_text_path(idea, branch)
  end
  
  def edit_text_branch_or_master_path idea, branch, text
    branch == "master" || branch.nil? ? edit_idea_text_path(idea) : edit_idea_branch_text_path(idea, branch, text)
  end
  
end
