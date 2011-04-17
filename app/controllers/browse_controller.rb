class BrowseController < ApplicationController
  
  before_filter :require_user
  
  def explore
    @ideas = Idea.where(:access => Idea::PUBLIC)
  end
  
end
