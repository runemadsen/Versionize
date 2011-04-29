module ApplicationHelper
  
  def find_idea_and_branch
    unless params[:branch_id].nil?
      # problem, I don't check for whether the branch and idea belongs to the user
      @branch = Branch.find(params[:branch_id])
      @idea = @branch.idea
    else
      @idea = current_user.published_idea params[:idea_id]
      @branch = @idea.branches.first
    end
  end
   
end
