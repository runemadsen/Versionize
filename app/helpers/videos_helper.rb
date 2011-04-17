module VideosHelper
  
  def new_video_branch_or_master_path idea, branch
     branch == "master" || branch.nil? ? new_idea_video_path(idea) : new_idea_branch_video_path(idea, branch)
   end
   
end
