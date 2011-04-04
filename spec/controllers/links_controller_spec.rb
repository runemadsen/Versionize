require 'spec_helper'

describe LinksController do
   
  setup :activate_authlogic
  fixtures :ideas, :users
   
  before do
    UserSession.create(users(:rune))
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @idea.create_repo
  end
   
  after do
    FileUtils.rm_rf @idea.repo
  end
 
  describe "GET new" do
    it "should show the link form" do
      Idea.should_receive(:find).with("1").and_return(@idea)  
      get :new, :idea_id => "1"
      response.should be_success
    end
  end

  describe "POST create" do
    it "should save link in repository and redirect" do
      Idea.should_receive(:find).with("37").and_return(@idea)
      post :create, { :idea_id => "37", :link => { :url => "www.runemadsen.com" } }
      response.should redirect_to(idea_path(@idea))
    end
  end
  
  describe "GET edit" do
    
    it "should grab the link from the repo" do
      pending "Missing test"
    end
  end
  
  describe "PUT update" do
    it "should commit the updated text using same filename" do
      pending "Missing test"
    end
  end
  
end
