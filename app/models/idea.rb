class Idea < ActiveRecord::Base

  include Grit
  
  has_many :collaborations
  has_many :users, :through => :collaborations
  
  REPO_PATH = 'repos/repo'
  REPO_EXT = '.git'
  
  def is_owner? user
    self.collaborations.each do |c|
      if user.id == c.user_id && c.owner
        return true
      end
    end
    false
  end
    
  def next_order
    self.repository.tree.contents.count
  end
  
  def create_repo(model, user, commit_msg)
    self.repo = REPO_PATH + (Idea.count + 1).to_s + REPO_EXT
    @repository = Repo.init_bare(self.repo)
    model.order = 9999999999
    index = Index.new(self.repository)
    index.add(model.generate_name, model.to_json)
    index.commit(commit_msg, nil, Actor.new("Versionize User", user.email))
  end
  
  def create_version(model, user, commit_msg, delete = false)
    index = Index.new(self.repository)
    index.read_tree('master')
    
    if delete
      index.delete(model.generate_name)
    else
      index.add(model.generate_name, model.to_json)
    end
    
    index.commit(commit_msg, [self.repository.commits.first], Actor.new("Versionize User", user.email))
  end
  
  def repository
    @repository ||= Repo.new self.repo
  end
  
  def file(file_name)
    blob_to_model(self.repository.tree/file_name)
  end
  
  def version(version)
    
    # Caching problem: 
    # Different versions operate on same array
    
    if @models != nil 
      return @models 
    end
    
    @models = []
    
    if version == 0
      self.repository.tree.contents.each do |blob|
        @models << blob_to_model(blob)
      end
    else
      self.repository.commits[num_commits-version.to_i].tree.contents.each do |blob|
        @models << blob_to_model(blob)
      end
    end
    
    @models.sort  {|x,y| y.order <=> x.order }
  end
  
  def num_commits
    @commit_num ||= self.repository.commit_count
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
