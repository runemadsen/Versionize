class LinksController < ApplicationController
  
   before_filter :require_user
   
   def new
     @idea = Idea.find(params[:idea_id])
     @link = Link.new
   end
   
   def edit
     @idea = Idea.find(params[:idea_id])
     @link = @idea.file(Link::name_from_uuid(params[:id]))
   end
  
   def create
      begin
        @idea = Idea.find(params[:idea_id])
        @link = Link.new params[:link]
        @link.order = @idea.next_order
        @idea.create_version(@link, @current_user, "Save link")
        flash[:notice] = "Saved link"
        redirect_to idea_path(@idea)
      rescue Exception => e 
        flash[:error] = "There was a problem! #{e}"
        redirect_to new_idea_link_path(@idea)
      end
   end
   
   def update
     begin
       @idea = Idea.find(params[:idea_id])
       @link = @idea.file(Link::name_from_uuid(params[:id]))
       @link.update(params[:link])
       @idea.create_version(@link, @current_user, "Updated link")
       flash[:notice] = "Saved Link"
       redirect_to idea_path(@idea)
     rescue Exception => e
       flash[:error] = "There was a problem! #{e}"
       redirect_to new_idea_link_path(@idea)
     end
   end
   
end