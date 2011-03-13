class LinksController < ApplicationController
  
   before_filter :require_user
   
   def new
   end
  
   def create
      idea = Idea.find(params[:idea_id])
      @repo = Repo.new(idea.repo)
      index = Index.new(@repo)
      
      for link in params[:links]
         index.add('link_' + UUID.generate + '.json', link)
      end
    
      index.commit("Added links", nil, Actor.new("Versionize User", @current_user.email))
      
      redirect_to idea_path(idea)
      
   end
   
end
