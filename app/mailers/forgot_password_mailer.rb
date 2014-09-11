class ForgotPasswordMailer < ActionMailer::Base

  def forgot_message(user)
    @user = user

    mail(to: user.email, subject: "Grizzly Feed - Forgot Password", from: "Grizzly Feed <do-not-reply@grizzlyfeed.com>")
  end
end