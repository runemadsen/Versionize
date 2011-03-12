class User < ActiveRecord::Base
  
  acts_as_authentic
  
  has_many :ideas
  
  def as_actor
    "Versionize User <" + self.email + ">"
  end
  
end
