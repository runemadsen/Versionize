class User < ActiveRecord::Base
  
  acts_as_authentic
  
  has_many :collaborations
  has_many :ideas, :through => :collaborations
  has_many :invites
  
  def published_ideas
    ideas.includes([:collaborations]).where :published => true
  end
  
  def published_idea idea_id
    ideas.includes([:collaborations]).where(:published => true, :id => idea_id).first
  end
  
  def as_actor
    "Versionize User <" + self.email + ">"
  end
  
  def invites_left
    self.allowed_invites - self.invites.count
  end
  
end
