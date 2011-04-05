module ImagesHelper
  
  def new_image_branch_or_master_path idea, branch
    branch == "master" ? new_idea_image_path(idea) : new_idea_branch_image_path(idea, branch)
  end
  
  def edit_image_branch_or_master_path idea, branch, image
    branch == "master" ? edit_idea_image_path(idea) : edit_idea_branch_image_path(idea, branch, image)
  end
end
