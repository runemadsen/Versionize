require 'spec_helper'

describe ImagesController do
  
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
  end

  after do
    FileUtils.rm_rf @idea.repo
  end

  describe "GET new" do
    it "should show the image form" do
      get :new, :idea_id => @idea.id
      assigns[:image_upload].should_not be_nil
      response.should be_success
    end
  end
  
end
