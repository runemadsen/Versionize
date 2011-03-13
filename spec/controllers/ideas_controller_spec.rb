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
    end
    
    before do
      @desc = "This is my RSpec idea description"
      @desc_updated = "This is my updated RSpec description"

      @idea1 = ideas(:idea_nolinks)
      @repo1 = Repo.init_bare 'repos/testrepo_nolinks.git'
      index1 = Index.new(@repo1)
      index1.add('text_' + UUID.generate + '.txt', @desc)
      index1.commit("bla")

      @repo3 = Repo.init_bare 'repos/testrepo_bare'

    end
    
    after do
      FileUtils.rm_rf 'repos/testrepo_links.git'
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
        Repo.should_receive(:init_bare).with(Idea::REPO_PATH + (Idea.count + 1).to_s + Idea::REPO_EXT).and_return(@repo3)
      end
      
      it "should create repo and save idea" do
        post :create, :idea => {:name => "My RSPEC Idea"}, :description => @desc
        assigns[:idea].should_not be_nil
        assigns[:repo].should_not be_nil
        assigns[:repo].commits.first.tree.contents.first.data.should == @desc
        response.should redirect_to(idea_path(assigns[:idea]))
      end
      
      it "should create actor from current user" do
        post :create, { :idea => {:name => "My RSPEC Idea"}, :description => @desc}
        assigns[:repo].commits.first.committer.email.should == assigns[:current_user].email
      end
        
    end
    
    describe "GET show" do
      
      it "should show basic idea details" do
        Idea.should_receive(:find).with("37").and_return(@idea1)
        get :show, :id => "37"
        response.should be_success
        assigns[:repo].should_not be_nil
        assigns[:repo].commits.first.tree.contents.first.data.should == @desc
      end

    end
    
  end
end
