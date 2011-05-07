require 'spec_helper'

describe Idea do
  
  fixtures :ideas, :users
  
  before do    
    @desc = "This is my RSpec idea description"
    @idea = ideas(:myidea)
    @text = Text.new(:body => @desc)
    @user = users(:rune)
    @idea.create_repo(@user)
    @idea.create_version("master", "newversion", users(:rune))
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
    it "should save model on master version without version specified" do
      @text = Text.new :body => "This is some text", :order => 1
      @idea.create_history(@text, users(:rune), "Save text")
      @idea.file(@text.generate_name).body.should == @text.body
      @idea.repository.commit_count("master").should == 1
    end  

    it "should save model on master version with master specified" do
      @text = Text.new :body => "This is some text", :order => 1
      @idea.create_history(@text, users(:rune), "Save text")
      @idea.file(@text.generate_name).body.should == @text.body
      @idea.repository.commit_count("master").should == 1
    end  

    it "should save model on newversion" do
      @text = Text.new :body => "This is some text", :order => 1
      @idea.create_history(@text, users(:rune), "Save text", @idea.versions[1])
      @idea.file(@text.generate_name, @idea.versions[1]).body.should == @text.body
      @idea.repository.commit_count("newversion").should == 1
      @idea.repository.commit_count("master").should == 0
    end
  end
  
  describe "create new version" do
    it "should create a new version from the given old version" do
      @text = Text.new :body => "This is some text", :order => 1
      @idea.create_history(@text, users(:rune), "Save text")
      @idea.create_version("master", "newversion", users(:rune))
      @idea.repository.heads.count.should == 2
    end  
  end
  
  describe "Files" do
    it "should return files depending on specified treeish" do
      @text = Text.new :body => "Text for master version", :order => 1
      @idea.create_history(@text, users(:rune), "Save text")
      @text.body = "Text for the newversion version"
      @idea.create_history(@text, users(:rune), "Save text", @idea.versions[1])
      @idea.files("master")[0].body.should == "Text for master version"
      @idea.files("newversion")[0].body.should == "Text for the newversion version"
    end
  end
  
  describe "File" do
    it "should return file depending on specified version" do
      @text = Text.new :body => "Text for master version", :order => 1
      @idea.create_history(@text, users(:rune), "Save text")
      @text.body = "Text for the newversion version"
      @idea.create_history(@text, users(:rune), "Save text", @idea.versions[1])
      @idea.file(@text.generate_name).body.should == "Text for master version"
      @idea.file(@text.generate_name, @idea.versions[1]).body.should == "Text for the newversion version"
    end
  end
  
  describe "next order" do
    it "should return next order depending on version" do
      @text = Text.new :body => "Text for master version", :order => 1
      @idea.create_history(@text, users(:rune), "Save text")
      @idea.next_order.should == 1
      @idea.next_order(@idea.versions[1]).should == 0
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
