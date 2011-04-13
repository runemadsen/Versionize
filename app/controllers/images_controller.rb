class ImagesController < ApplicationController
  
  include ApplicationHelper
  before_filter :require_user
  before_filter :find_branch
  
  def new
    
    @idea = Idea.find params[:idea_id]
    
    expiration = 20.years.from_now
    key = "users/#{current_user.id}/images/#{Time.now.strftime('%Y%m%d%H%M%S')}"

    @image_upload = Ungulate::FileUpload.new(
      :bucket_url => "http://#{Rails.application.config.bucket}.s3.amazonaws.com/",
      :key => key,
      :policy => {
        'expiration' => expiration,
        'conditions' => [
          {'bucket' => Rails.application.config.bucket},
          {'key' => key},
          {'acl' => 'public-read'},
          ['content-length-range', 0, 10000000],
          {'success_action_redirect' => upload_success_idea_images_url}
        ]
      }
    )
    
  end
  
  def upload_succes
    begin
      @idea = Idea.find(params[:idea_id])
      @image = Image.new(:key => params[:key])
      @image.order = @idea.next_order(@branch)
      @idea.create_version(@image, @current_user, "Save Image", false, @branch)
      flash[:notice] = "Saved image"
      redirect_to idea_branch_or_master_path(@idea)
    rescue Exception => e 
      flash[:error] = "There was a problem! #{e}"
      redirect_to new_image_branch_or_master_path(@idea)
    end
  end
  
  def destroy
    begin
      @idea = Idea.find(params[:idea_id])
      @image = @idea.file(Image::name_from_uuid(params[:id]), @branch)
      @idea.create_version(@image, @current_user, "delete image", true, @branch)
      flash[:notice] = "Removed Image"
      redirect_to idea_branch_or_master_path(@idea, @branch)
    rescue Exception => e
      flash[:error] = "There was a problem! #{e}"
      redirect_to idea_branch_or_master_path(@idea, @branch)
    end
  end

end
