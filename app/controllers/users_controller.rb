class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "nouser"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "static_pages.sample_app_welcome"
      redirect_to @user
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end
end
