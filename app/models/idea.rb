class Idea < ActiveRecord::Base
  
  belongs_to :user
  
  FILENAME_DESC = 'description.txt'
  FILENAME_LINKS = 'links.json'
  REPO_PATH = 'repos/repo'
  REPO_EXT = '.git'
  COMMIT_MESSAGE = 'Updated idea'
  
end
