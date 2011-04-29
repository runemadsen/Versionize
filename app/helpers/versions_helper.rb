module VersionsHelper
  
  def find_version_by_params
    @version = params[:id]
    raise Exception, "This version does not exist" if params[:id].to_i > @idea.commits(@branch).count
  end
  
end
