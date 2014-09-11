class Api::UsersController < ApiController
  skip_before_filter :user_not_signed_in, :only => [:forgot_password]
  
  def update_password
    if current_user.authenticate(params[:current_password])
      if current_user.update_attributes(password: params[:password], password_confirmation: params[:password_confirmation])
        sign_in current_user
        render json: {status: 'Success'}
      else
        render json: {status: 'Error', errors: current_user.errors.full_messages}, status: 400
      end
    else
      render json: {status: 'Error', errors: ['Failed to authenticate based on the current password provided']}, status: 401
    end
  end

  def forgot_password
    @user = User.find_by_email(params[:email])
    if @user
      @user.generate_password_reset
      ForgotPasswordMailer.forgot_message(@user).deliver
    end
    render json: {status: 'Success'}
  end

  def themes
    @themes = Theme.all.map { |t| {id: t.id, name: t.name, style: t.stylesheet, active: t == theme} }
    render json: @themes
  end

  def layouts
    @layouts = Layout.all.map { |l| {id: l.id, name: l.name, icon: l.icon, active: l == layout} }
    render json: @layouts
  end

  def update_theme
    @theme = Theme.find(params[:theme_id])
    if @theme
      current_user.theme = @theme
      current_user.save(validate: false)
      sign_in current_user
      render json: {status: 'Success'}
    else
      @response = {status: 'Error', errors: ['Theme not found']}
      render json: @response, status: 400 
    end
  end

  def update_layout
    @layout = Layout.find(params[:layout_id])
    if @layout
      current_user.layout = @layout
      current_user.save(validate: false)
      sign_in current_user
      render json: {status: 'Success'}
    else
      @response = {status: 'Error', errors: ['Layout not found']}
      render json: @response, status: 400
    end
  end

  def get_welcome
    render json: {status: 'Success', welcome_stage: current_user.welcome_stage}
  end

  def update_welcome
    @next_stage = params[:next]
    if current_user.update_welcome_stage(@next_stage)
      sign_in current_user
      render json: {status: 'Success', welcome_stage: @next_stage}
    else
      render json: {status: 'Error', errors: ['Failed to update welcome stage']}, status: 401
    end
  end

end