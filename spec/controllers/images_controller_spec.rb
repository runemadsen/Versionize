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
    @image = Image.new(:key => "users/1/images/20100809")
    @image.order = @idea.next_order
    @idea.create_history(@image, @user, "Added Image", @idea.versions.first)
    @idea.create_version("master", "newversion", @user)
    @idea.save
  end

  after do
    FileUtils.rm_rf @idea.repo
  end

  describe "GET new" do
    it "should show the image form for specified version" do
      get :new, :idea_id => @idea.id, :version_id => "master"
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      assigns[:image_upload].should_not be_nil
      response.should be_success
    end
  end
  
  describe "Upload success" do
    it "should save key and redirect to idea path" do
      get :upload_succes, :idea_id => @idea.id, :version_id => "master", :key => "users/1/images/20100908"
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      response.should redirect_to(idea_path(@idea))
    end
    it "should save key and redirect to version path" do
      get :upload_succes, :idea_id => @idea.id, :version_id => "newversion", :key => "users/1/images/20100908"
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      response.should redirect_to(idea_version_path(@idea, "newversion"))
    end
  end
  
  describe "GET edit" do
    it "should show the edit form for specified version" do
      get :edit, :idea_id => @idea.id, :version_id => "master", :id => @image.uuid
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      assigns[:image].should_not be_nil
      response.should be_success
    end
  end
  
  describe "DELETE destroy" do
    it "should delete image for specified version" do
      delete :destroy, :idea_id => @idea.id, :version_id => "master", :id => @image.uuid
      assigns[:idea].should_not be_nil
      assigns[:version].should_not be_nil
      assigns[:image].should_not be_nil
      response.should redirect_to(idea_path(@idea))
    end
  end
  
end
