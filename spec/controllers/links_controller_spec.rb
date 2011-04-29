require 'spec_helper'

describe LinksController do
   
  setup :activate_authlogic
  fixtures :ideas, :users
   
  before do
    @user = users(:rune)
    UserSession.create(@user)
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @idea.save
    @idea.create_repo(@user)
    @link = Link.new(:url => "www.runemadsen.com")
    @link.order = @idea.next_order
    @idea.create_version(@link, @user, "Added link")
    @idea.create_branch("master", "newbranch", @user)
  end
   
  after do
    FileUtils.rm_rf @idea.repo
  end
 
  describe "GET new" do
    it "should show the link form" do
      get :new, :idea_id => @idea.id, :branch_id => 1
      assigns[:idea].should_not be_nil
      assigns[:branch].should_not be_nil
      assigns[:branch_num].should_not be_nil
      response.should be_success
    end
  end

  describe "POST create" do
    it "should save link in master and redirect to idea" do
      post :create, { :idea_id => "37", :branch_id => 1, :link => { :url => "www.runemadsen.com", :notes => "This is my notes" } }
      assigns[:link].url.should == "www.runemadsen.com"
      assigns[:link].notes.should == "This is my notes" 
      response.should redirect_to(idea_path(@idea))
    end
    
    it "should save link in branch and redirect to branch" do
      post :create, { :idea_id => "37", :branch_id => 2, :link => { :url => "www.runemadsen.com" } }
      response.should redirect_to(idea_branch_path(@idea, 2))
    end
  end
  
  describe "GET edit" do
    it "should show the edit form for specified branch" do
      get :edit, :idea_id => @idea.id, :branch_id => 1, :id => @link.uuid
      assigns[:idea].should_not be_nil
      assigns[:branch].should_not be_nil
      assigns[:link].should_not be_nil
      response.should be_success
    end
  end
  
  describe "DELETE destroy" do
    it "should delete image for specified branch" do
      delete :destroy, :idea_id => @idea.id, :branch_id => 1, :id => @link.uuid
      assigns[:idea].should_not be_nil
      assigns[:branch].should_not be_nil
      assigns[:link].should_not be_nil
      response.should redirect_to(idea_path(@idea))
    end
  end
end
