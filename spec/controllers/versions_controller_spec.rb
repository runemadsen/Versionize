require 'spec_helper'

describe VersionsController do
  
  setup :activate_authlogic
  fixtures :users, :ideas
  
  before do
    @user = users(:rune)
    UserSession.create(@user)
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @private_idea = ideas(:private_idea)
    @public_idea = ideas(:public_idea)
    @idea.save
    @private_idea.save
    @public_idea.save
    @coll = Collaboration.create! :user => @user, :idea => @idea, :owner => true
    @idea.create_repo
    @private_idea.create_repo
    @public_idea.create_repo
    @text = Text.new :body => "Text for master branch", :order => 1
    @idea.create_version(@text, users(:rune), "Save text")
    @private_idea.create_version(@text, users(:rune), "Save text")
    @public_idea.create_version(@text, users(:rune), "Save text")
  end
  
  after do
    FileUtils.rm_rf @idea.repo
    @idea.destroy
    @private_idea.destroy
    @public_idea.destroy
    @coll.destroy
  end
  
  describe "GET show" do
     
    it "should show idea in public mode if owner (can't edit older versions)" do
      Idea.should_receive(:where).with(:id => "37", :published => true).at_least(:once).and_return(@idea)
      get :show, :id => "1", :idea_id => "37"
      assigns[:idea].should_not be_nil
      assigns[:edit].should == false
      response.should be_success
    end
    
    it "should show idea in public mode if not owner and idea is public" do
      Idea.should_receive(:where).with(:id => "39", :published => true).at_least(:once).and_return(@public_idea)
      get :show, :id => "1", :idea_id => "39"
      assigns[:idea].should_not be_nil
      assigns[:edit].should == false
      response.should be_success
    end
         
    it "should deny access on private idea if not owner and idea is private" do
      Idea.should_receive(:where).with(:id => "38", :published => true).at_least(:once).and_return(@private_idea)
      get :show, :id => "1", :idea_id => "38"
      assigns[:idea].should_not be_nil
      response.should redirect_to(ideas_path)
    end
    
    it "should throw error if version doesnt exist" do
      
    end
    
    it "should grab branch name if specified" do
    end
    
    it "should set branch to master if branch not specified" do
    end
    
  end

end
