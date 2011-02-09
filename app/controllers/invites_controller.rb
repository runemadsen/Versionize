class InvitesController < ApplicationController
  
  layout "front"
  
  def index
  end
  
  def create
    invite = Invite.new(:email => params[:invitemail])
    invite.save
    render 'thanks'
  end
  
end
