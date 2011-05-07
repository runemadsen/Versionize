module VideosHelper
  
  def new_video_version_or_idea_path idea, version
     version.alias == "master" || version.nil? ? new_idea_video_path(idea) : new_idea_version_video_path(idea, version.alias)
   end
   
end
