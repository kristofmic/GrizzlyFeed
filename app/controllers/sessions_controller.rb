class SessionsController < ApplicationController
  def new
    redirect_to hash_route(feeds_path) if signed_in?
  end

  def create
    @user = User.find_by_email(params[:email].downcase)
    if(@user && @user.authenticate(params[:password]))
      sign_in @user
      redirect_to hash_route(feeds_path)
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    sign_out
    flash.now[:success] = "Successfully signed out"
    render 'new'
  end
end