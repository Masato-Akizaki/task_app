class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :admin_user
  
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
    @user = User.find_by(id: params[:id])
    if @user&.destroy
      flash[:success] = "ユーザーを削除しました"
      redirect_to admin_users_path
    elsif @user.nil?
      flash[:danger] = "ユーザーが存在しませんでした"
      redirect_to admin_users_path
    else
      @tasks = User.find(params[:id]).tasks.order(created_at: :desc).page(params[:page]).per(20)
      render "show"
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation, :admin)
    end

    def admin_user
      render_403 unless current_user.admin?
    end

end
