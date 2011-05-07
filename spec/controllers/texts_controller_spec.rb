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
    @idea.create_repo(@user)
    @text = Text.new(:body => "This is my text")
    @text.order = @idea.next_order
    @idea.create_history(@text, @user, "Added text", @idea.versions.first)
  end

  after do
    FileUtils.rm_rf @idea.repo
  end
  
  describe "GET new" do
    it "should show the text form" do
      get :new, :idea_id => @idea.id, :version_id => "master"
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      response.should be_success
    end
  end
  
  describe "POST create" do
    it "should save text " do
      post :create, { :idea_id => 37, :version_id => "master", :text => { :body => "This is some text" } }
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      response.should redirect_to(idea_path(@idea))
    end
  end
  
  describe "GET edit" do
    it "should show the edit form for specified version" do
      get :edit, :idea_id => @idea.id, :version_id => "master", :id => @text.uuid
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      assigns[:text].should_not be_nil
      response.should be_success
    end
  end
  
  describe "DELETE destroy" do
    it "should delete image for specified version" do
      delete :destroy, :idea_id => @idea.id, :version_id => "master", :id => @text.uuid
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      assigns[:text].should_not be_nil
      response.should redirect_to(idea_path(@idea))
    end
  end
    
end
