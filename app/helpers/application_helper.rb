module ApplicationHelper
  
  def idea_branch_or_master_path idea, params
    unless params[:branch_id].nil?
      idea_branch_path(idea, params[:branch_id])
    else
      idea_path(idea)
    end
  end
  
  def new_idea_branch_or_master_path idea, params
    unless params[:branch_id].nil?
      new_idea_branch_text_path(idea, params[:branch_id])
    else
      new_idea_text_path(idea)
    end
  end
  
end
