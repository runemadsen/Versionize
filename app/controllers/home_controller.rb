class HomeController < ApplicationController
 
  before_filter :require_user
 
  def index
    # if logged in - redirect to 
    # render the login screen
  end
 
end