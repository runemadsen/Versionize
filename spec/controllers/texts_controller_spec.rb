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
    @text = Text.new(:body => "This is my RSpec idea description")
  end

  after do
    FileUtils.rm_rf @idea.repo
  end
  
  describe "GET new" do
    # it "should show the text form" do
    #       get :new, :idea_id => @idea.id
    #       response.should be_success
    #     end
  end
  
  describe "POST create" do
    
    it "should save text without branch specified" do
      post :create, { :idea_id => "37", :branch_id => "1", :text => { :body => "This is some text" } }
      # assigns[:idea].should_not be_nil
      # assigns[:branch].should_not be_nil
      response.should redirect_to(idea_path(@idea))
    end
    #    
    #    it "should save text with branch specified" do
    #      post :create, { :idea_id => "37", :branch_id => "2", :text => { :body => "This is some text" } }
    #      response.should redirect_to(branch_path("2"))
    #    end
       
  end
    
end
