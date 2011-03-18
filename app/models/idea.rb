class Idea < ActiveRecord::Base

  include Grit
  belongs_to :user
  
  REPO_PATH = 'repos/repo'
  REPO_EXT = '.git'
  
  def next_order
    self.repository.tree.contents.count
  end
  
  def create_repo(model, user, commit_msg)
    self.user = user
    self.repo = REPO_PATH + (Idea.count + 1).to_s + REPO_EXT
    @repository = Repo.init_bare(self.repo)
    model.order = 9999999999
    index = Index.new(self.repository)
    index.add(model.generate_name, model.to_json)
    index.commit(commit_msg, nil, Actor.new("Versionize User", user.email))
  end
  
  def create_version(model, user, commit_msg)
    index = Index.new(self.repository)
    index.read_tree('master')
    index.add(model.generate_name, model.to_json)
    index.commit(commit_msg, [self.repository.commits.first], Actor.new("Versionize User", user.email))
  end
  
  def repository
    @repository ||= Repo.new self.repo
  end
  
  def current_version 
    files = []
    self.repository.tree.contents.each do |blob|
      name = blob.name.split("_")[0].capitalize
      file = name.constantize.new(JSON.parse(blob.data))
      file.name = blob.name
      file.id = blob.id
      files << file
    end
    files.sort  {|x,y| y.order <=> x.order }
  end
  
  def num_commits
    self.repository.commits.count
  end
  
end
