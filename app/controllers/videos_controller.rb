class VideosController < ApplicationController
  
  include ApplicationHelper
  before_filter :require_user
  before_filter :find_branch
  
  def new
  end
  
end
