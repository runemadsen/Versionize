require 'spec_helper'

describe Idea do
  
  fixtures :ideas, :users
  
  before do    
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @text = Text.new(:body => @desc)
    @user = users(:rune)
    @idea.create_repo(@user)
    @idea.create_branch("master", "newbranch", users(:rune))
  end

  after do
    FileUtils.rm_rf @idea.repo
  end
  
  describe "on instantiation" do
    it "should generate repo name" do
      idea = Idea.new
      idea.repo.should_not be_nil
    end
  end
  
  describe "create version" do
    it "should save model on master branch without branch specified" do
      @text = Text.new :body => "This is some text", :order => 1
      @idea.create_version(@text, users(:rune), "Save text")
      @idea.file(@text.generate_name).body.should == @text.body
      @idea.repository.commit_count("master").should == 1
    end  

    it "should save model on master branch with master specified" do
      @text = Text.new :body => "This is some text", :order => 1
      @idea.create_version(@text, users(:rune), "Save text")
      @idea.file(@text.generate_name).body.should == @text.body
      @idea.repository.commit_count("master").should == 1
    end  

    it "should save model on newbranch" do
      @text = Text.new :body => "This is some text", :order => 1
      @idea.create_version(@text, users(:rune), "Save text", @idea.branches[1])
      @idea.file(@text.generate_name, @idea.branches[1]).body.should == @text.body
      @idea.repository.commit_count("newbranch").should == 1
      @idea.repository.commit_count("master").should == 0
    end
  end
  
  describe "create new branch" do
    it "should create a new branch from the given old branch" do
      @text = Text.new :body => "This is some text", :order => 1
      @idea.create_version(@text, users(:rune), "Save text")
      @idea.create_branch("master", "newbranch", users(:rune))
      @idea.repository.heads.count.should == 2
    end  
  end
  
  describe "Files" do
    it "should return files depending on specified treeish" do
      @text = Text.new :body => "Text for master branch", :order => 1
      @idea.create_version(@text, users(:rune), "Save text")
      @text.body = "Text for the newbranch branch"
      @idea.create_version(@text, users(:rune), "Save text", @idea.branches[1])
      @idea.files("master")[0].body.should == "Text for master branch"
      @idea.files("newbranch")[0].body.should == "Text for the newbranch branch"
    end
  end
  
  describe "File" do
    it "should return file depending on specified branch" do
      @text = Text.new :body => "Text for master branch", :order => 1
      @idea.create_version(@text, users(:rune), "Save text")
      @text.body = "Text for the newbranch branch"
      @idea.create_version(@text, users(:rune), "Save text", @idea.branches[1])
      @idea.file(@text.generate_name).body.should == "Text for master branch"
      @idea.file(@text.generate_name, @idea.branches[1]).body.should == "Text for the newbranch branch"
    end
  end
  
  describe "next order" do
    it "should return next order depending on branch" do
      @text = Text.new :body => "Text for master branch", :order => 1
      @idea.create_version(@text, users(:rune), "Save text")
      @idea.next_order.should == 1
      @idea.next_order(@idea.branches[1]).should == 0
    end
  end
  
  describe "public / private" do
    it "should default to private" do
      idea = Idea.new
      idea.access.should == Idea::PRIVATE
    end
    
    it "should be able to set to public" do
      idea = Idea.new
      idea.access = Idea::PUBLIC
      idea.access.should == Idea::PUBLIC
    end
    
  end
  
end
