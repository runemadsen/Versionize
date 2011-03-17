class Idea < ActiveRecord::Base

  include Grit
  belongs_to :user
  
  REPO_PATH = 'repos/repo'
  REPO_EXT = '.git'
  
  def create_repo(user)
    self.user = user
    self.repo = REPO_PATH + (Idea.count + 1).to_s + REPO_EXT
    @repository = Repo.init_bare(self.repo)
  end
  
  def create_version(model, user, commit_msg)
    index = Index.new(self.repository)
    index.add(model.generate_name, model.to_json)
    index.commit(commit_msg, nil, Actor.new("Versionize User", user.email))
  end
  
  def repository
    @repository ||= Repo.new self.repo
  end
  
  def current_version 
    files = []
    self.repository.tree.contents.each do |blob|
      name = blob.name.split("_")[0].capitalize
      files << name.constantize.new(JSON.parse(blob.data))
    end
    files
  end
  
  def num_commits
    @repository.commits.count
  end
  
end
