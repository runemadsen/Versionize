class InvitesController < ApplicationController
  
  def create
    invite = Invite.new(:email => params[:invitemail])
    invite.save
    render 'thanks'
  end
  
end
