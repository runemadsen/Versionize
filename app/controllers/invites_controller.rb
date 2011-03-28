class InvitesController < ApplicationController
  
  before_filter :require_user
  
  def index
    @invite = @current_user.invites.new
  end
  
  def create
    begin
      invite = Invite.new(:email => params[:invitemail])
      invite.save
      render 'thanks'
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "Something went wrong: #{e}"
      redirect_to invites_path
    end
  end
  
end
