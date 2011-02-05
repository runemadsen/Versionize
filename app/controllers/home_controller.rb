class HomeController < ApplicationController
 
  before_filter :require_user
  
  layout "front"
 
  def index
  end
 
end