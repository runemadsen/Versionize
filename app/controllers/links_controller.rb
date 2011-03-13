class LinksController < ApplicationController
  
   before_filter :require_user
   
   def new
   end
  
   def create
      begin
         idea = Idea.find(params[:idea_id])
         @repo = Repo.new(idea.repo)
         index = @repo.index
         index.read_tree('master')
      
         for link in params[:links]
            index.add('link_' + UUID.generate + '.json', link)
         end
    
         index.commit("Added links", [@repo.commits.first], Actor.new("Versionize User", @current_user.email))

         redirect_to idea_path(idea)
         
      rescue Exception => e 
         flash[:error] = "There was a problem! #{e}"
         redirect_to new_idea_link_path(@idea)
      end
      
   end
   
end



# def tree_list(ref)
#       sha    = @access.ref_to_sha(ref)
#       commit = @access.commit(sha)
#       tree_map_for(sha).inject([]) do |list, entry|
#         next list unless @page_class.valid_page_name?(entry.name)
#         list << entry.page(self, commit)
#       end
#     end