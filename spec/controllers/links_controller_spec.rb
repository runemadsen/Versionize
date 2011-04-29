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
  end
   
  after do
    FileUtils.rm_rf @idea.repo
  end
 
  describe "GET new" do
    # it "should show the link form" do
    #       get :new, :idea_id => @idea.id
    #       response.should be_success
    #     end
  end

  describe "POST create" do
    
    # it "should save link without branch specified" do
    #       post :create, { :idea_id => "37", :link => { :url => "www.runemadsen.com" } }
    #       assigns[:link].url.should == "www.runemadsen.com" 
    #       response.should redirect_to(idea_path(@idea))
    #     end
    #     
    #     it "should save link with branch specified" do
    #       post :create, { :branch_id => "37", :link => { :url => "www.runemadsen.com" } }
    #       assigns[:link].url.should == "www.runemadsen.com" 
    #       response.should redirect_to(idea_path(@idea))
    #     end
    #     
    #     it "should save extra info in repository and redirect" do
    #       post :create, { :idea_id => "37", :link => { :url => "www.runemadsen.com", :notes => "This is my notes" } }
    #       assigns[:link].notes.should == "This is my notes" 
    #       response.should redirect_to(idea_path(@idea))
    #     end
    #     
    #     it "should save link in repository on newbranch and redirect" do
    #       post :create, { :idea_id => "37", :branch_id => "newbranch", :link => { :url => "www.runemadsen.com" } }
    #       response.should redirect_to(idea_branch_path(@idea, "newbranch"))
    #     end
  
  end
end
