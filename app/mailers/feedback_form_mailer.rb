class FeedbackFormMailer < ActionMailer::Base
  
  def feedback_message(feedback)
    @name = feedback.name
    @email = feedback.email
    @message = feedback.message

    mail(to: "chris@grizzlyfeed.com", subject: "Feedback - #{feedback.title}", from: "#{@email}")
  end
end