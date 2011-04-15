require 'spec_helper'

describe TextsController do
   
  setup :activate_authlogic
  fixtures :ideas, :users
   
  before do
    @user = users(:rune)
    UserSession.create(@user)
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @idea.save
    Collaboration.create! :user => @user, :idea => @idea, :owner => true
    @idea.create_repo
    @text = Text.new(:body => "This is my RSpec idea description")
  end

  after do
    FileUtils.rm_rf @idea.repo
  end
  
  describe "GET new" do
    it "should show the text form" do
      get :new, :idea_id => @idea.id
      response.should be_success
    end
  end
  
  describe "POST create" do
    
    it "should save text without branch specified" do
      post :create, { :idea_id => "37", :text => { :body => "This is some text" } }
      response.should redirect_to(idea_path(@idea))
    end
    
    it "should save text with branch specified" do
      post :create, { :idea_id => "37", :branch_id => "newbranch", :text => { :body => "This is some text" } }
      response.should redirect_to(idea_branch_path(@idea, "newbranch"))
    end
       
  end
    
end
