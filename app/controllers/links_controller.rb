class LinksController < ApplicationController
  
   before_filter :require_user
   
   def new
     @idea = Idea.find(params[:idea_id])
     @link = Link.new
   end
  
   def create
      begin
         link = Link.new params[:link]
         idea = Idea.find(params[:idea_id])
         @repo = Repo.new(idea.repo)
         index = @repo.index
         index.read_tree('master')
         index.add(link.generate_name, link.to_json)
         index.commit("Added link", [@repo.commits.first], Actor.new("Versionize User", @current_user.email))
         redirect_to idea_path(idea)
         
      rescue Exception => e 
         flash[:error] = "There was a problem! #{e}"
         redirect_to new_idea_link_path(@idea)
      end
      
   end
   
end