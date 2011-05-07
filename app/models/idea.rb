class Idea < ActiveRecord::Base

  include Grit
  
  has_many :versions
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
    
  def next_order(version = nil)
    version = version.nil? ? versions.first : version
    self.repository.tree(version.alias).contents.count
  end
  
  def create_repo user
    @repository = Repo.init_bare(self.repo)
    collaborations.create(:user => user, :owner => true)
    versions.create(:name => "Original", :alias => "master")
  end
  
  def create_history(model, user, commit_msg, version = nil, delete = false)
    version = version.nil? ? versions.first : version  
    index = Index.new(self.repository)
    index.read_tree(version.alias)
    if delete
      index.delete(model.generate_name)
    else
      index.add(model.generate_name, model.to_json)
    end
    index.commit(commit_msg, self.repository.commit_count > 0 ? [self.repository.commit(version.alias)] : nil, Actor.new("Versionize User", user.email), nil, version.alias)
  end
  
  def create_version(oldversion, newversion, user)
    master = versions.where(:alias => oldversion).first
    version = versions.create(:name => newversion, :alias => Version.clean_alias(newversion), :parent_id => master.id)
    index = Index.new(self.repository)
    index.read_tree(oldversion)
    index.commit("Created version: " + version.name, [self.repository.commit(oldversion)], Actor.new("Versionize User", user.email), nil, version.alias)
  end
  
  def commits(version)
    version.parent.nil? ? repository.commits(version.alias) : repository.commits_between(version.parent.alias, version.alias).reverse # is this reverse?
  end
  
  def file(file_name, version = nil)
    version = version.nil? ? versions.first : version 
    blob_to_model(self.repository.tree(version.alias)/file_name)
  end
  
  def files(treeish)
    @models = []
    repository.tree(treeish).contents.each do |blob|
      @models << blob_to_model(blob)
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
