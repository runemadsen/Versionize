class InvitesController < ApplicationController
  
  layout "front"
  
  def index
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
