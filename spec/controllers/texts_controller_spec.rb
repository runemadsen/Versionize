require 'spec_helper'

describe TextsController do
   
  setup :activate_authlogic
  fixtures :ideas, :users
   
  before do
    UserSession.create(users(:rune))    
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @text = Text.new(:body => @desc)
    @idea.create_repo(@text, users(:rune), "Init commit")
  end

  after do
    FileUtils.rm_rf @idea.repo
  end
  
  describe "GET new" do
    it "should show the text form" do
      Idea.should_receive(:find).with("1").and_return(@idea)
      get :new, :idea_id => "1"
      response.should be_success
    end
  end
  
  describe "POST create" do
    
    it "should save text in repository" do
      Idea.should_receive(:find).with("37").and_return(@idea)
      post :create, { :idea_id => "37", :text => { :body => "This is some text" } }
      assigns[:idea].repository.tree.contents[0].data.should == @text.to_json
      response.should redirect_to(idea_path(@idea))
    end
      
    it "should assign text order of 1" do
      Idea.should_receive(:find).with("37").and_return(@idea)
      post :create, { :idea_id => "37", :text => { :body => "This is some text" } }
      assigns[:text].order.should == 1
    end
    
  end
   
  describe "GET edit" do
    it "should grab the text file from the repo" do
      Idea.should_receive(:find).with("37").and_return(@idea)
      get :edit, :idea_id => "37", :id => @idea.current_version[0].uuid
      assigns[:text].id.should == @idea.current_version[0].id
      assigns[:text].file_name.should_not be_nil
      assigns[:text].body.should_not be_nil
      response.should be_success
    end
  end
  
  describe "PUT update" do
    it "should commit the updated text using same filename" do
      Idea.should_receive(:find).with("37").and_return(@idea)
      put :update, :idea_id => "37", :id => @idea.current_version[0].uuid, :text => { :body => @text.body, :order => @text.order, :file_name => @text.file_name}
      assigns[:idea].repository.commits.count.should == 2
      assigns[:idea].repository.tree.blobs.count.should == 1
      assigns[:text].file_name.should == @text.file_name
      response.should redirect_to(idea_path(@idea))
    end
    
  end
    
end
