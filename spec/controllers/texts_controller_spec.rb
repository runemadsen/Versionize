require 'spec_helper'

describe TextsController do
   
   setup :activate_authlogic
   fixtures :ideas, :users
   
   before do
      UserSession.create(users(:rune))
      
      @desc = "This is my RSpec idea description"
      @idea = ideas(:myidea)
      @repo = Repo.init_bare @idea.repo
      index = Index.new(@repo)
      index.add('text_' + UUID.generate + '.txt', @desc)
      index.commit("Bla")
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
         Repo.should_receive(:new).with(@idea.repo).and_return(@repo)
         post :create, { :idea_id => "37", :text => { :body => "This is some text" } }
         assigns[:idea].repository.tree.contents[1].data.should == "{\"body\":\"This is some text\"}"
         assigns[:idea].repository.tree.contents[0].data.should == @desc
         response.should redirect_to(idea_path(@idea))
      end
    
   end
end
