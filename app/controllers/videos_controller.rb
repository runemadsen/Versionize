class VideosController < ApplicationController
  
  include ApplicationHelper
  before_filter :require_user
  
  def new
    begin
      find_idea_and_branch_by_params
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
end
