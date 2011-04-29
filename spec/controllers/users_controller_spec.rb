require 'spec_helper'

describe UsersController do
  
  setup :activate_authlogic
  fixtures :ideas, :users
  
  describe "POST 'create'" do
    it "should create a new user" do
      post :create, {:user => { :email => "test@test.dk", :password => "test", :password_confirmation => "test" }, :code => "ITPINVITE"}
      response.should redirect_to('/')
    end
    
    it "should throw error when password dont match" do
      post :create, {:user => { :email => "test@test.dk", :password => "test", :password_confirmation => "test1" }, :code => "ITPINVITE"}
      flash[:error].should == "Your passwords doesn't match or user already created"
      response.should redirect_to(new_user_path)
    end
    
    it "should throw error when code is not correct" do
      post :create, {:user => { :email => "test@test.dk", :password => "test", :password_confirmation => "test" }, :code => "ITPWRONG"}
      flash[:error].should == "You have entered a wrong invitation code, or you code doesn't match your email adress"
      response.should redirect_to(new_user_path)
    end
  end

end
