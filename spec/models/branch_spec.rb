require 'spec_helper'

describe Branch do
  
  it "should create alias on instantiation" do
    b = Branch.new :name => "Runes Branch", :alias => "Runes Branch"
    b.name.should == "Runes Branch"
    b.alias.should == "runes-branch"
  end
  
  it "should reject names longer than 30 character" do
  end
  
end
