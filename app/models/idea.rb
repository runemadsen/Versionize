class Idea < ActiveRecord::Base
  
  belongs_to :user
  
  REPO_PATH = 'repos/repo'
  REPO_EXT = '.git'
  
end
