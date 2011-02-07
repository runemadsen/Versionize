require 'spec_helper'

describe "A User" do
  
  before do
    @attr = { :email => "user@example.com",
              :password => 'test1234',
              :password_confirmation => 'test1234'
            }
  end
  
  it "should create a new instance" do
     
    @user = User.new(@attr) 
    @user.should be_valid
    @user.save.should be_true
    puts @user.errors.full_messages.to_sentence
    
  end
  
end