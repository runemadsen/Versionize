class InvitesController < ApplicationController
  
  before_filter :require_user
  
  def index
    @invite = @current_user.invites.new
  end
  
  def create
    
    begin
      invite = Invite.new(params[:invite])
      invite.user = @current_user
      invite.code = ActiveSupport::SecureRandom.hex(3)
      
      invite.save
      InviteMailer.invite_email(invite).deliver
      render 'confirmation'
    rescue Exception => e 
      flash[:error] = "Something went wrong: #{e}"
      redirect_to user_invites_path(@current_user)
    end
    
  end
  
end
