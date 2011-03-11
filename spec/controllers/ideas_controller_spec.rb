require 'spec_helper'

describe IdeasController do
  
  setup :activate_authlogic
  fixtures :users, :ideas
  
  before do
    
    @desc = "This is my RSpec idea description"
    
    @repo1 = Repo.init_bare 'repos/testrepo_nolinks.git'
    index1 = Index.new(@repo1)
    index1.add(Idea::FILENAME_DESC, @desc)
    index1.commit(Idea::COMMIT_MESSAGE)
    
    @repo2 = Repo.init_bare 'repos/testrepo_links.git'
    index2 = Index.new(@repo2)
    index2.add(Idea::FILENAME_DESC, @desc)
    index2.add(Idea::FILENAME_LINKS, '["http://www.domain1.com", "http://www.domain2.com", "http://www.domain3.com"]')
    index2.commit(Idea::COMMIT_MESSAGE)
    
  end
  
  after do
    
    FileUtils.rm_rf 'repos/testrepo_nolinks.git'
    FileUtils.rm_rf 'repos/testrepo_links.git'
    
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
    
    describe "visits an ideas show page" do
      
      it "should show the idea without links" do
        
        idea = ideas(:idea_nolinks)
        Idea.should_receive(:find).with("37").and_return(idea)
        
        get :show, :id => "37"
        
        response.should be_success
        assigns[:repo].should_not be_nil
        assigns[:links].should be_nil
        assigns[:description].should == @desc
        
      end
      
      it "should show the idea with links" do
        
        idea = ideas(:idea_links)
        Idea.should_receive(:find).with("37").and_return(idea)
        
        get :show, :id => "37"
        
        response.should be_success
        assigns[:repo].should_not be_nil
        assigns[:links].should_not be_nil
        assigns[:links].should be_an_instance_of Array
        assigns[:description].should == @desc
        
      end

    end
    
    describe "creates new idea" do
      
      it "should create a bare repo" do
        post :create, { :idea => {:name => "My Idea"}, :description => "This is my description" }
        assigns[:idea].should_not be_nil
        assigns[:repo].should_not be_nil
      end
      
      it "should redirect to show" do
        post :create, :idea => {:name => "My Idea"}
        response.should redirect_to(idea_path(assigns[:idea]))
      end
        
      it "should not create links.json if no links params exist" do 
      end
                    
      it "should save links params if links params exit" do 
      end
    end
    
    
  end
end
