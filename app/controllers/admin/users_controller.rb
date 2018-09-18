class Admin::UsersController < ApplicationController
  before_action  :logged_in_user
  #before_action  :admin_user
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザー登録が完了しました"
      redirect_to admin_users_path
    else
      render "new"
    end
  end

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(50)
  end

  def show
    @user = User.find_by(id: params[:id])
    @tasks = User.find(params[:id]).tasks.order(created_at: :desc).page(params[:page]).per(20)
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @tasks = User.find(params[:id]).tasks.order(created_at: :desc).page(params[:page]).per(20)
    if @user.nil?
      render "show"
    elsif @user.destroy
      flash[:success] = "ユーザーを削除しました"
      redirect_to admin_users_path
    else
      render "show"
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation, :admin)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end