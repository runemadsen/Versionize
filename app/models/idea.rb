class Idea < ActiveRecord::Base

  include Grit
  belongs_to :user
  
  REPO_PATH = 'repos/repo'
  REPO_EXT = '.git'
  
  def load_repo
    @repository = Repo.new self.repo
  end
  
  def current_version
    files = []
    @repository.tree.contents.each do |blob|
      name = blob.name.split("_")[0].capitalize
      files << name.constantize.new(JSON.parse(blob.data))
    end
    files
  end
  
  def num_commits
    @repository.commits.count
  end
  
end
