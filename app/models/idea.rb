class Idea < ActiveRecord::Base

  include Grit
  
  has_many :collaborations
  has_many :users, :through => :collaborations
  
  REPO_PATH = 'repos/repo'
  REPO_EXT = '.git'
  
  def after_initialize
    if self.repo.nil?
      self.repo = REPO_PATH + (Idea.count + 1).to_s + REPO_EXT
    end
  end
  
  def repository
    @repository ||= Repo.new self.repo
  end
  
  def is_owner? user
    self.collaborations.each do |c|
      if user.id == c.user_id && c.owner
        return true
      end
    end
    false
  end
    
  def next_order(branch = "master")
    self.repository.tree(branch).contents.count
  end
  
  def create_repo
    @repository = Repo.init_bare(self.repo)
  end
  
  def create_version(model, user, commit_msg, delete = false, branch = "master")
    index = Index.new(self.repository)
    index.read_tree(branch)
    if delete
      index.delete(model.generate_name)
    else
      index.add(model.generate_name, model.to_json)
    end
    index.commit(commit_msg, self.repository.commit_count > 0 ? [self.repository.commits.first] : nil, Actor.new("Versionize User", user.email), nil, branch)
  end
  
  def create_branch(oldbranch, newbranch, user)
    index = Index.new(self.repository)
    index.read_tree(oldbranch)
    index.commit("Created Branch", self.repository.commit_count > 0 ? [self.repository.commits.first] : nil, Actor.new("Versionize User", user.email), nil, newbranch)
  end
  
  def num_commits(branch = "master")
    if branch.nil?
      branch = "master"
    end
    self.repository.commit_count(branch)
  end
  
  def file(file_name, branch = "master")
    if branch.nil?
      branch = "master"
    end
    blob_to_model(self.repository.tree(branch)/file_name)
  end
  
  def version(version, branch = "master")
    
    if branch.nil?
      branch = "master"
    end
    # this should really, really, really be cached
    
    @models = []
    
    if version == 0
      self.repository.tree(branch).contents.each do |blob|
        @models << blob_to_model(blob)
      end
    else
      self.repository.commits[num_commits(branch)-version.to_i].tree(branch).contents.each do |blob|
        @models << blob_to_model(blob)
      end
    end
    
    @models.sort  {|x,y| y.order <=> x.order }
  end
  
  private
  
  def blob_to_model(blob)
    name = blob.name.split("_")[0].capitalize
    file = name.constantize.new(JSON.parse(blob.data).merge({:file_name => blob.name}))
    file.file_name = blob.name
    file.id = file.uuid
    file
  end
  
end
