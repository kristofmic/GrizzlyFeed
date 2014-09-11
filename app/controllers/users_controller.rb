class UsersController < ApplicationController
  before_filter :user_not_signed_in, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Congratulations! You're now a member"
      redirect_to feeds_path
    else
      render 'new'
    end
  end

  def show
    @user = current_user
    render partial: 'users/show'
  end

  def reset_password
    # We are using the ! version of this method so that a 404 error will be thrown if the user is not found.
    @user = User.find_by_password_reset_token(params[:token])
    if @user.nil? || @user.password_reset_sent_at < 2.hours.ago  
      flash[:danger] = "Password reset link expired. Please try again if you do not remember your password"
      redirect_to login_path
    end
  end

  def update_password
    @user = User.find_by_password_reset_token(params[:token])
    if @user.nil? || @user.password_reset_sent_at < 2.hours.ago  
      flash[:danger] = "Password reset link expired. Please try again if you do not remember your password"
      redirect_to login_path
    elsif @user.update_attributes(params[:user])
      @user.clear_password_reset
      sign_in @user
      redirect_to feeds_path
    else
      render 'reset_password'
    end
  end

end