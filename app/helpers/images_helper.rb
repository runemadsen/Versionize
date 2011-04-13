module ImagesHelper
  
  def new_image_branch_or_master_path idea, branch
    branch == "master" || branch.nil? ? new_idea_image_path(idea) : new_idea_branch_image_path(idea, branch)
  end
  
  def edit_image_branch_or_master_path idea, branch, image
    branch == "master" || branch.nil? ? edit_idea_image_path(idea) : edit_idea_branch_image_path(idea, branch, image)
  end
end
