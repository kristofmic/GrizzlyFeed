module SessionsHelper
  def sign_in user
    cookies.permanent[:cookie_token] = user.cookie_token
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete :cookie_token
    current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= current_user_from_db
  end

  def current_user_from_db
    User.find_by_cookie_token(cookies[:cookie_token])
  end

  def current_user? user
    current_user == user
  end

  def user_not_signed_in
    unless signed_in?
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end
end