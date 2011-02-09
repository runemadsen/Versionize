class HomeController < ApplicationController
 
  #before_filter :require_user
 
  def index
    
    unless current_user
      redirect_to invites_url
    end
    
  end
 
end