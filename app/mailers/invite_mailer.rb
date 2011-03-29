class InviteMailer < ActionMailer::Base
  default :from => "hello@versionize.com"
  
  def invite_email(invite)
    @invite = invite
    mail(:to => invite.to_email, :subject => "You have been invited to Versionize")
  end
end
