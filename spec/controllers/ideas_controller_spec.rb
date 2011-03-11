require 'spec_helper'

describe IdeasController do
  
  setup :activate_authlogic
  fixtures :users, :ideas
  
  before do
    
    @desc = "This is my RSpec idea description"
    
    @idea1 = ideas(:idea_nolinks)
    @repo1 = Repo.init_bare 'repos/testrepo_nolinks.git'
    index1 = Index.new(@repo1)
    index1.add(Idea::FILENAME_DESC, @desc)
    index1.commit(Idea::COMMIT_MESSAGE)
    
    @idea2 = ideas(:idea_links)
    @repo2 = Repo.init_bare 'repos/testrepo_links.git'
    index2 = Index.new(@repo2)
    index2.add(Idea::FILENAME_DESC, @desc)
    index2.add(Idea::FILENAME_LINKS, '["http://www.domain1.com", "http://www.domain2.com", "http://www.domain3.com"]')
    index2.commit(Idea::COMMIT_MESSAGE)
    
    @repo3 = Repo.init_bare 'repos/testrepo_bare'
    
  end
  
  after do
    
    FileUtils.rm_rf 'repos/testrepo_nolinks.git'
    FileUtils.rm_rf 'repos/testrepo_links.git'
    FileUtils.rm_rf 'repos/testrepo_bare'
    
  end
  
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
    
    describe "visits the index page" do
  
      it "should get response success" do
        get :index
        response.should be_success
      end
      
    end
    
    describe "POST create" do
      
      it "should create repo and save idea without links" do
        Repo.should_receive(:init_bare).with(Idea::REPO_PATH + (Idea.count + 1).to_s + Idea::REPO_EXT).and_return(@repo3)
        post :create, { :idea => {:name => "My Idea"}, :description => "This is my description" }
        assigns[:idea].should_not be_nil
        assigns[:repo].should_not be_nil
        (assigns[:repo].commits.first.tree/Idea::FILENAME_LINKS).should be_nil
        
        response.should redirect_to(idea_path(assigns[:idea]))
      end
      
      it "should create repo and save idea without links" do
        Repo.should_receive(:init_bare).with(Idea::REPO_PATH + (Idea.count + 1).to_s + Idea::REPO_EXT).and_return(@repo3)
        post :create, { :idea => {:name => "My Idea"}, :description => "This is my description", :links => ["www.runemadsen.com", "www.pol.dk"] }
        assigns[:idea].should_not be_nil
        assigns[:repo].should_not be_nil
        (assigns[:repo].commits.first.tree/Idea::FILENAME_LINKS).should_not be_nil
        
        response.should redirect_to(idea_path(assigns[:idea]))
      end
        
    end
    
    describe "GET show" do
      
      it "should show the idea without links" do
        
        Idea.should_receive(:find).with("37").and_return(@idea1)
        
        get :show, :id => "37"
        
        response.should be_success
        assigns[:repo].should_not be_nil
        assigns[:links].should be_nil
        assigns[:description].should == @desc
        
      end
      
      it "should show the idea with links" do
        
        Idea.should_receive(:find).with("37").and_return(@idea2)
        
        get :show, :id => "37"
        
        response.should be_success
        assigns[:repo].should_not be_nil
        assigns[:links].should be_an_instance_of Array
        assigns[:description].should == @desc
        
      end

    end
    
    describe "GET edit" do
        
        it "should show idea without links" do
          
          Idea.should_receive(:find).with("37").and_return(@idea1)

          get :edit, :id => "37"

          response.should be_success
          assigns[:repo].should_not be_nil
          assigns[:links].should be_nil
          assigns[:description].should == @desc
          
        end
        
        it "should show idea with links" do
          
          Idea.should_receive(:find).with("37").and_return(@idea2)

          get :edit, :id => "37"

          response.should be_success
          assigns[:repo].should_not be_nil
          assigns[:links].should be_an_instance_of Array
          assigns[:description].should == @desc
          
        end
        
    end
    
    
  end
end
