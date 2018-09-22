class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        remember_user user
        redirect_back_or user
      else
        activate_warning
      end
    else
      invalid_warning
    end
  end

  def destroy
    request_logout
  end

  private

  def remember_user user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def activate_warning
    flash[:warning] = t ".message"
    redirect_to root_url
  end

  def invalid_warning
    flash.now[:danger] = t ".invalid"
    render :new
  end

  def request_logout
    log_out if logged_in?
    redirect_to root_url
  end
end
