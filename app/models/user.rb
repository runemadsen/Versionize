class User < ActiveRecord::Base
  
  acts_as_authentic
  
  has_many :collaborations
  has_many :ideas, :through => :collaborations
  has_many :invites
  
  def ideas_owner
    ideas.where(:owner => true)
  end
  
  def ideas_collaborator
    ideas.where(:owner => false)
  end
  
  def as_actor
    "Versionize User <" + self.email + ">"
  end
  
  def invites_left
    self.allowed_invites - self.invites.count
  end
  
end
