module IdeasHelper
  
  def link_to_version idea, branch_id, version_num
    
    # problem: idea.num_commits is not getting back the branch commits, but master commits
    if branch_id.nil? || branch_id == 0
      if version_num == idea.num_commits
        idea_path(idea)
      else
        idea_version_path(idea, version_num)
      end
    else
      if version_num == idea.num_commits
        idea_branch_path(idea, branch_id)
      else
        idea_branch_version_path(idea, branch_id, version_num)
      end
    end
  end

end
