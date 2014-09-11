class GeneralsController < ApplicationController

  def main
  end

  def home
    #redirect_to feeds_path if signed_in? 
    render partial: 'generals/home'
  end

  def policies
    render partial: 'generals/policies'
  end

  def about
    render partial: 'generals/about'
  end

  def support
    render partial: 'generals/support'
  end

  def feedback
    @feedback = Feedback.new
  end

  def send_feedback
    @feedback = Feedback.new(params[:feedback])
    if @feedback.save
      FeedbackFormMailer.feedback_message(@feedback).deliver
      flash.now[:success] = "Your message has been sent. Thanks for the feedback!"
      @feedback = Feedback.new
    end
    render 'feedback'
  end
end