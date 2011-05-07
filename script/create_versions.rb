ideas = Idea.all

ideas.each do |idea|
  
  begin
    # create master branch
    master = idea.versions.create(:name => "Original", :alias => "master")
  
    # create all other branches
    idea.repository.heads.each do |head|
    
      if head.name != "master"
        idea.versions.create(:name => head.name.capitalize, :alias => head.name, :parent_id => master.id)
      end
    end
  rescue Exception => e
    puts "Error with idea: #{idea.id}: #{e}"
  end
end

 puts "Done"