module IdeasHelper
  
  def link_to_version idea, branch, version_num
    
    if branch.nil? || branch == "master"
      if version_num == idea.num_commits(branch)
        idea_path(idea)
      else
        idea_version_path(idea, version_num)
      end
    else
      if version_num == idea.num_commits(branch)
        idea_branch_path(idea, branch)
      else
        idea_branch_version_path(idea, branch, version_num)
      end
    end
  end

end
