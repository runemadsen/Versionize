require 'spec_helper'

describe IdeasController do
  
  setup :activate_authlogic
  fixtures :users
  
  describe "User not logged in" do
    it "should not GET index" do
      get :index
      response.should redirect_to("/user_sessions/new")
    end
  end
  
  describe "User Logged in" do
    
    describe "GET requests" do
      
      it "should GET index" do
        UserSession.create(users(:rune))
        get :index
        response.should be_success
      end
      
    end
    
    describe "POST requests" do
          
      it "should redirect to show" do
        UserSession.create(users(:rune))
        post :create, :menu_item => {:name => "My Idea", :text => "This is my idea"}
        response.should redirect_to(idea_path(assigns[:idea]))
      end
        
      it "should not create links.json if no links params exist" do 
      end
                    
      it "should save links params if links params exit" do end
      end
  end

end
