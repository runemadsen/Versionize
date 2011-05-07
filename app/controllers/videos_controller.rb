class VideosController < ApplicationController
  
  include ApplicationHelper
  before_filter :require_user
  
  def new
    begin
      find_idea_and_version_by_params(params[:idea_id], params[:version_id])
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
end
