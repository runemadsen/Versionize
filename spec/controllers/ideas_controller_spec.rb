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
        @user = users(:rune)
        UserSession.create(@user)
        @desc = "This is my RSpec idea description"
        @idea = ideas(:myidea)
        @idea.save
        @idea.create_repo(@user)
      end
      
      after do
        FileUtils.rm_rf @idea.repo
        @idea.destroy
      end
    
      describe "GET index" do
         it "should get response success" do
            get :index
            response.should be_success
         end
      end
      
      describe "GET show" do
         
        it "should show idea as edit if owner" do
          Idea.should_receive(:find_by_id_and_published).with("37", true).at_least(:once).and_return(@idea)
          get :show, :id => "37"
          assigns[:idea].should_not be_nil
          assigns[:edit].should == true
          response.should be_success
        end
        
        it "should show idea in public mode if not owner and idea is public" do
          Idea.should_receive(:find_by_id_and_published).with("39", true).at_least(:once).and_return(ideas(:public_idea))
          get :show, :id => "39"
          assigns[:idea].should_not be_nil
          assigns[:edit].should == false
          response.should be_success
        end
         
        it "should deny access on private idea if not owner and idea is private" do
          Idea.should_receive(:find_by_id_and_published).with("38", true).at_least(:once).and_return(ideas(:private_idea))
          get :show, :id => "38"
          assigns[:idea].should_not be_nil
          response.should redirect_to(ideas_path)
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
