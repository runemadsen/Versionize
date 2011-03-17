class LinksController < ApplicationController
  
   before_filter :require_user
   
   def new
     @idea = Idea.find(params[:idea_id])
     @link = Link.new
   end
  
   def create
      begin
         link = Link.new params[:link]
         @idea = Idea.find(params[:idea_id])
         @idea.create_version(link, @current_user, "Save link")
         redirect_to idea_path(@idea)
      rescue Exception => e 
         flash[:error] = "There was a problem! #{e}"
         redirect_to new_idea_link_path(@idea)
      end
      
   end
   
end