module ImagesHelper
  
  def new_image_branch_or_master_path idea, branch
    branch == "master" || branch.nil? ? new_idea_image_path(idea) : new_idea_branch_image_path(idea, branch)
  end
  
  def edit_image_branch_or_master_path idea, branch, image
    branch == "master" || branch.nil? ? edit_idea_image_path(idea, image.id) : edit_idea_branch_image_path(idea, branch, image.id)
  end
  
  def upload_success_branch_or_master_url idea, branch
    branch == "master" || branch.nil? ? upload_success_idea_images_url : upload_success_idea_branch_images_url
  end
  
  def image_branch_or_master_path idea, branch, image
    branch == "master" || branch.nil? ? idea_image_path(idea, image.id) : idea_branch_image_path(idea, branch, image.id)
  end
  
end
