ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'grizzlyfeed.com',
  :authentication => :plain,

  :user_name => 'do-not-reply@grizzlyfeed.com ',
  :password => 'N9yI1*knDyR1%UQP'
}