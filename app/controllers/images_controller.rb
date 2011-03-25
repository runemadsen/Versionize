class ImagesController < ApplicationController
  
  def new
    
    @idea = Idea.find params[:idea_id]
    
    expiration = 20.years.from_now
    key = "users/#{current_user.id}/images/#{Time.now.strftime('%Y%m%d%H%M%S')}"

    @image_upload = Ungulate::FileUpload.new(
      :bucket_url => "http://versionize.s3.amazonaws.com/",
      :key => key,
      :policy => {
        'expiration' => expiration,
        'conditions' => [
          {'bucket' => 'versionize'},
          {'key' => key},
          {'acl' => 'public-read'},
          {'success_action_redirect' => 'http://localhost:3000' + upload_success_idea_images_path}
        ]
      }
    )
    
  end
  
  def upload_succes
    begin
      @idea = Idea.find(params[:idea_id])
      @image = Image.new(:key => params[:key])
      @image.order = @idea.next_order
      @idea.create_version(@image, current_user, "Save Image")
      flash[:notice] = "Saved image"
      redirect_to idea_path(@idea)
    rescue Exception => e 
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_idea_image_path(@idea)
    end
  end
  
end