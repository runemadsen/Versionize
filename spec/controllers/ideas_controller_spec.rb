require 'spec_helper'


describe IdeasController do
  
   setup :activate_authlogic
   fixtures :users, :ideas
  
   describe "User not logged in" do
      it "should not GET index" do
         get :index
         response.should redirect_to("/user_sessions/new")
      end
   end
  
   describe "A logged in user performing" do

      before do
        UserSession.create(users(:rune))
        @idea = ideas(:myidea)
      end
    
      describe "GET index" do
         it "should get response success" do
            get :index
            response.should be_success
         end
      end
    
      describe "POST create" do
      
        it "should create repo and save idea" do
          Idea.should_receive(:new).once.and_return(@idea)
          post :create, :idea => {:name => "My RSPEC Idea"}, :description => @desc
          response.should redirect_to(idea_path(assigns[:idea]))
        end
        
      end
  end
end
