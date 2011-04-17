class BrowseController < ApplicationController
  
  before_filter :require_user
  
  def index
    @ideas = Idea.where(:access => Idea::PUBLIC)
  end
  
end
