module VideosHelper
  
  def new_video_branch_or_idea_path idea, branch
     branch.alias == "master" || branch.nil? ? new_idea_video_path(idea) : new_idea_branch_video_path(idea, branch.alias)
   end
   
end
