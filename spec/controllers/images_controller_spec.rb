require 'spec_helper'

describe ImagesController do
  
  setup :activate_authlogic
  fixtures :ideas, :users

  before do
    @user = users(:rune)
    UserSession.create(@user)
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @idea.create_repo(@user)
    @idea.save
  end

  after do
    FileUtils.rm_rf @idea.repo
  end

  describe "GET new" do
    it "should show the image form" do
      get :new, :idea_id => @idea.id
      assigns[:idea].should_not be_nil
      assigns[:branch].should_not be_nil
      assigns[:image_upload].should_not be_nil
      response.should be_success
    end
    
    it "should show the image form on branch" do
      get :new, :branch_id => @idea.id
      assigns[:idea].should_not be_nil
      assigns[:branch].should_not be_nil
      assigns[:image_upload].should_not be_nil
      response.should be_success
    end
  end
  
end
