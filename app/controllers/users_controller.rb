class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update destroy)
  before_action :find_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "static_pages.home.homeapp"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "delete"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "nouser"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "please_log"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
