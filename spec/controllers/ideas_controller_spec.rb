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
  
   describe "A logged in user" do

      before do
         UserSession.create(users(:rune))
         @desc = "This is my RSpec idea description"
         @desc_updated = "This is my updated RSpec description"
         @idea = ideas(:myidea)
         @repo = Repo.init_bare @idea.repo
      end
    
      after do
         FileUtils.rm_rf 'repos/testrepo.git'
         FileUtils.rm_rf 'repos/testrepo_bare'
      end
    
      describe "GET index" do
         it "should get response success" do
            get :index
            response.should be_success
         end
      end
    
      describe "POST create" do
      
         before do
            Repo.should_receive(:init_bare).with(Idea::REPO_PATH + (Idea.count + 1).to_s + Idea::REPO_EXT).and_return(@repo)
         end
      
         it "should create repo and save idea" do
            post :create, :idea => {:name => "My RSPEC Idea"}, :description => @desc
            assigns[:idea].should_not be_nil
            assigns[:idea].repository.should_not be_nil
            assigns[:idea].repository.tree.contents.first.data.should == assigns[:text].to_json
            response.should redirect_to(idea_path(assigns[:idea]))
         end
      
         it "should create actor from current user" do
            post :create, { :idea => {:name => "My RSPEC Idea"}, :description => @desc}
            assigns[:idea].repository.commits.first.committer.email.should == assigns[:current_user].email
         end  
         
         it "should save order 0 in description" do
             post :create, { :idea => {:name => "My RSPEC Idea"}, :description => @desc}
             assigns[:text].order.should == 9999999999
          end
      end
    
      describe "GET show" do
         it "should show basic idea details" do
            Idea.should_receive(:find).with("37").and_return(@idea)
            get :show, :id => "37"
            response.should be_success
            assigns[:idea].current_version.should_not be_nil
         end
      end
  end
end
