require 'spec_helper'

describe ImagesController do
  
  setup :activate_authlogic
  fixtures :ideas, :users

  before do
    UserSession.create(users(:rune))
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @idea.create_repo
  end

  after do
    FileUtils.rm_rf @idea.repo
  end

  describe "GET new" do
    it "should show the image form" do
      Idea.should_receive(:find).with("1").and_return(@idea)  
      get :new, :idea_id => "1"
      assigns[:image_upload].should_not be_nil
      response.should be_success
    end
  end
  
end
