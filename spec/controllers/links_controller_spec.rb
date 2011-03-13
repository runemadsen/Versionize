require 'spec_helper'

describe LinksController do
   
   setup :activate_authlogic
   fixtures :ideas, :users
   
   before do
      UserSession.create(users(:rune))
      
      @desc = "This is my RSpec idea description"
      @idea1 = ideas(:idea_nolinks)
      @repo1 = Repo.init_bare 'repos/testrepo_nolinks.git'
      index1 = Index.new(@repo1)
      index1.add('text_' + UUID.generate + '.txt', @desc)
      index1.commit("Bla")
   end
   
   after do
      FileUtils.rm_rf 'repos/testrepo_nolinks.git'
   end
  
   describe "GET new" do
    
      it "should show the link form" do
         get :new, :idea_id => "1"
         response.should be_success
      end
    
   end
  
   describe "POST create" do
    
      it "should save link(s) in repository" do
         Idea.should_receive(:find).with("37").and_return(@idea1)
         Repo.should_receive(:new).with(@idea1.repo).and_return(@repo1)
         post :create, { :idea_id => "37", :links => ["www.runemadsen.com", "www.pol.dk"] }
         assigns[:repo].commits.first.tree.contents[0].data.should == @desc
         assigns[:repo].commits.first.tree.contents[1].data.should == "www.runemadsen.com"
         assigns[:repo].commits.first.tree.contents[2].data.should == "www.pol.dk"
      end
    
   end
end
