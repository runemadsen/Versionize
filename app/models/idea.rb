class Idea < ActiveRecord::Base

  include Grit
  
  has_many :branches
  has_many :collaborations
  has_many :users, :through => :collaborations
  
  REPO_PATH = 'repos/repo'
  REPO_EXT = '.git'
  PRIVATE = 0
  PUBLIC = 1
  
  def after_initialize
    if self.repo.nil?
      self.repo = REPO_PATH + (Idea.count + 1).to_s + REPO_EXT
    end
  end
  
  def private?
    return access == PRIVATE
  end
  
  def public?
    return access == PUBLIC
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
  
  def is_collaborator? user
    self.collaborations.each do |c|
      if user.id == c.user_id
        return true
      end
    end
    false
  end
    
  def next_order(branch)
    self.repository.tree(branch.alias).contents.count
  end
  
  def create_repo user
    @repository = Repo.init_bare(self.repo)
    collaborations.create(:user => user, :owner => true)
    branches.create(:name => "Original", :alias => "master")
  end
  
  def create_version(model, user, commit_msg, branch, delete = false)
    index = Index.new(self.repository)
    index.read_tree(branch.alias)
    if delete
      index.delete(model.generate_name)
    else
      index.add(model.generate_name, model.to_json)
    end
    index.commit(commit_msg, self.repository.commit_count > 0 ? [self.repository.commits.first] : nil, Actor.new("Versionize User", user.email), nil, branch.alias)
  end
  
  def create_branch(oldbranch, newbranch, user)
    master = branches.where(:alias => oldbranch).first
    branch = branches.create(:name => newbranch, :alias => newbranch, :parent_id => master.id)
    index = Index.new(self.repository)
    index.read_tree(oldbranch)
    index.commit("Created branch: " + branch.name, self.repository.commit_count > 0 ? [self.repository.commits.first] : nil, Actor.new("Versionize User", user.email), nil, branch.alias)
  end
  
  def commits(branch)
    branch.parent.nil? ? repository.commits(branch.alias) : repository.commits_between(branch.parent.alias, branch.alias)
  end
  
  def num_commits(branch)
    branch.parent.nil? ? repository.commit_count(branch) : repository.commits_between(branch.parent.alias, branch.alias).count
  end
  
  def file(file_name, branch)
    blob_to_model(self.repository.tree(branch.alias)/file_name)
  end
  
  def version(version, branch)
    @models = []
    
    if version == 0
      self.repository.tree(branch.alias).contents.each do |blob|
        @models << blob_to_model(blob)
      end
    else
      self.repository.commits[num_commits(branch)-version.to_i].tree(branch.alias).contents.each do |blob|
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
