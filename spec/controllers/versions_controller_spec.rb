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
    @text = Text.new :body => "Text for master branch", :order => 1
    @idea.create_version(@text, users(:rune), "Save text", @idea.branches.first)
    @private_idea.create_version(@text, users(:rune), "Save text", @private_idea.branches.first)
    @public_idea.create_version(@text, users(:rune), "Save text", @public_idea.branches.first)
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
     
   it "should show idea in public mode if owner (can't edit older versions)" do
     get :show, :id => @idea.repository.commit("master").sha, :idea_id => "37", :branch_id => "master"
     assigns[:idea].should_not be_nil
     assigns[:branch].should_not be_nil
     assigns[:edit].should == false
     assigns[:tree].should_not be_nil
     response.should be_success
   end
  
   it "should show idea in public mode if not owner and idea is public" do
     get :show, :id => @idea.repository.commit("master").sha, :idea_id => "39", :branch_id => "master"
     assigns[:idea].should_not be_nil
     assigns[:tree].should_not be_nil
     assigns[:edit].should == false
     response.should be_success
   end
    
    # it "should deny access on private idea if not owner and idea is private" do
    #       get :show, :id => 1, :idea_id => "38", :branch_id => 1
    #       assigns[:idea].should_not be_nil
    #       response.should redirect_to(ideas_path)
    #     end
    #     
    
    it "should throw error if version doesnt exist" do
      get :show, :id => 2, :idea_id => "38", :branch_id => "master"
      flash[:error].should_not be_nil
      response.should redirect_to(ideas_path)
    end
    
  end

end
