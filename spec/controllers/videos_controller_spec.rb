require 'spec_helper'

describe VideosController do

  setup :activate_authlogic
  fixtures :ideas, :users
   
  before do
    @user = users(:rune)
    UserSession.create(@user)
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @idea.save
    @idea.create_repo(@user)
  end
   
  after do
    FileUtils.rm_rf @idea.repo
  end
 
  describe "GET new" do
    it "should show the video form" do
      get :new, :idea_id => @idea.id, :branch_id => 1
      assigns[:idea].should_not be_nil
      assigns[:branch].should_not be_nil
      assigns[:branch_num].should_not be_nil
      response.should be_success
    end
  end
  
end
