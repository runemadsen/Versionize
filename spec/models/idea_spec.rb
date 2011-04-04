require 'spec_helper'

describe Idea do
  
  fixtures :ideas, :users
  
  before do    
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @text = Text.new(:body => @desc)
    @idea.create_repo
  end

  after do
    FileUtils.rm_rf @idea.repo
  end
  
  it "should generate repo name on initialize" do
    idea = Idea.new
    idea.repo.should_not be_nil
  end
  
  it "should save model on master branch without branch specified" do
    @text = Text.new :body => "This is some text", :order => 1
    @idea.create_version(@text, users(:rune), "Save text")
    (@idea.repository.tree/@text.generate_name).data.should == @text.to_json
    @idea.repository.commit_count("master").should == 1
  end  
  
  it "should save model on master branch with master specified" do
    @text = Text.new :body => "This is some text", :order => 1
    @idea.create_version(@text, users(:rune), "Save text", false, "master")
    (@idea.repository.tree/@text.generate_name).data.should == @text.to_json
    @idea.repository.commit_count("master").should == 1
  end  
  
  it "should save model on newbranch" do
    @text = Text.new :body => "This is some text", :order => 1
    @idea.create_version(@text, users(:rune), "Save text", false, "newbranch")
    (@idea.repository.tree("newbranch")/@text.generate_name).data.should == @text.to_json
    @idea.repository.commit_count("newbranch").should == 1
    @idea.repository.commit_count("master").should == 0
  end
  
  
end
