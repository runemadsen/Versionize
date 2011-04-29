class ImagesController < ApplicationController
  
  include ApplicationHelper
  before_filter :require_user
  
  def new
    begin
      find_idea_and_branch_by_params
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
            {'success_action_redirect' => upload_success_idea_branch_images_url(@idea, @branch_num)}
          ]
        }
      )
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def edit
    begin
      find_idea_and_branch_by_params
      @image = @idea.file(Image::name_from_uuid(params[:id]), @branch.alias)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end
  end
  
  def upload_succes
    begin
      find_idea_and_branch_by_params
      @image = Image.new(:key => params[:key])
      @image.order = @idea.next_order(@branch.alias)
      @idea.create_version(@image, @current_user, "Added Image", false, @branch.alias)
      flash[:notice] = "Saved image"
      redirect_to branch_or_idea_path(@idea, @branch_num)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to ideas_path
    end       
  end
  
  def destroy
    
    @idea = current_user.published_idea params[:idea_id]
    
    unless @idea.nil?
      begin
        @idea = Idea.find(params[:idea_id])
        @image = @idea.file(Image::name_from_uuid(params[:id]), @branch)
        @idea.create_version(@image, @current_user, "Deleted image", true, @branch)
        flash[:notice] = "Removed Image"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      rescue Exception => e
        flash[:error] = "There was a problem! #{e}"
        redirect_to idea_branch_or_idea_path(@idea, @branch)
      end
    else
      flash[:error] = "you do not have access to adding images to this idea"
      redirect_to idea_branch_or_idea_path(@idea, @branch)
    end
  end

end
