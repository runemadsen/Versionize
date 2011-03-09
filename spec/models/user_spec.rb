require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :email => "akm2000@gmail.com",
      :password => "D1ff1cultPa55w0rd",
      :password_confirmation => "D1ff1cultPa55w0rd",
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end