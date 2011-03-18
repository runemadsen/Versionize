require 'spec_helper'

describe LinksController do
   
  setup :activate_authlogic
  fixtures :ideas, :users
   
  before do
    UserSession.create(users(:rune))
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @idea.create_repo(Text.new(:body => @desc), users(:rune), "Init commit")
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
      assigns[:idea].repository.tree.contents.first.data.should == assigns[:link].to_json
      response.should redirect_to(idea_path(@idea))
    end
    
    it "should assign link order of 1" do
      Idea.should_receive(:find).with("37").and_return(@idea)
      post :create, { :idea_id => "37", :link => { :url => "www.runemadsen.com" } }
      assigns[:link].order.should == 1
    end
  end
end
