ActionMailer::Base.smtp_settings = {
  :address              => "smtp.emailsrvr.com",
  :port                 => 25,
  :user_name            => "hello@versionize.com",
  :password             => "Enurmadsen1",
  :authentication       => :login,
  :enable_starttls_auto => false
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
ActionMailer::Base.raise_delivery_errors = true
