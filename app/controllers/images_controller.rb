class ImagesController < ApplicationController
  
  include ApplicationHelper
  before_filter :require_user
  
  def new
    begin
      find_idea_and_version_by_params(params[:idea_id], params[:version_id])
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
            {'success_action_redirect' => upload_success_idea_version_images_url(@idea, @version.alias)}
          ]
        }
      )
    rescue Exception => e
      puts e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def edit
    begin
      find_idea_and_version_by_params(params[:idea_id], params[:version_id])
      @image = @idea.file(Image::name_from_uuid(params[:id]), @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def upload_succes
    begin
      find_idea_and_version_by_params(params[:idea_id], params[:version_id])
      @image = Image.new(:key => params[:key])
      @image.order = @idea.next_order(@version)
      @idea.create_history(@image, @current_user, "Added Image", @version)
      flash[:notice] = "Saved image"
      redirect_to version_or_idea_path(@idea, @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end       
  end
  
  def destroy
    begin
      find_idea_and_version_by_params(params[:idea_id], params[:version_id])
      @image = @idea.file(Image::name_from_uuid(params[:id]), @version)
      @idea.create_history(@image, @current_user, "Deleted image", @version, true)
      flash[:notice] = "Removed Image"
      redirect_to version_or_idea_path(@idea, @version)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end

end
