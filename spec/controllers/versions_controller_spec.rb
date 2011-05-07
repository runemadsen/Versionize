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
    @idea.create_repo(@user)
    @private_idea.create_repo(@user)
    @public_idea.create_repo(@user)
    @text = Text.new :body => "Text for master version", :order => 1
    @idea.create_history(@text, users(:rune), "Save text", @idea.versions.first)
    @private_idea.create_history(@text, users(:rune), "Save text", @private_idea.versions.first)
    @public_idea.create_history(@text, users(:rune), "Save text", @public_idea.versions.first)
  end
  
  after do
    FileUtils.rm_rf @idea.repo
    FileUtils.rm_rf @private_idea.repo
    FileUtils.rm_rf @public_idea.repo
    @idea.destroy
    @private_idea.destroy
    @public_idea.destroy
  end
  
  describe "GET show" do
     
    it "should set basic params" do
      get :show, :id => "master", :idea_id => "37"
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      assigns[:tree].should_not be_nil
      response.should be_success
    end

    it "should show idea in edit mode if owner" do
      get :show, :id => "master", :idea_id => "37"
      assigns[:edit].should == true
    end
    
    # it "should show idea in public mode if not owner and idea is public" do
    #       Idea.should_receive(:find_by_id_and_published).with("39", true).at_least(:once).and_return(@public_idea)
    #       get :show, :id => "newversion", :idea_id => "39"
    #       assigns[:idea].should_not be_nil
    #       assigns[:edit].should == false
    #       response.should be_success
    #     end
         
    # it "should deny access on private idea if not owner and idea is private" do
    #       Idea.should_receive(:find_by_id_and_published).with("38", true).at_least(:once).and_return(@private_idea)
    #       get :show, :id => "newversion", :idea_id => "38"
    #       assigns[:idea].should_not be_nil
    #       response.should redirect_to(ideas_path)
    #     end
    
    it "should show error if version doesn't exist" do
    end
    
  end
  
  describe "POST create" do
    it "should create version and redirect to version" do
      post :create, :idea_id => "37", :version_name => "My New version"
      assigns[:idea].should_not be_nil
      response.should redirect_to(idea_version_path("37", "my-new-version"))
    end
  end

end
