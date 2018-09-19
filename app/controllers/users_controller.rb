class UsersController < ApplicationController
  before_action :require_login, only: [:index, :show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザー登録が完了しました！"
      redirect_to root_path
    else
      render "new"
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user&.destroy
      flash[:success] = "アカウントを削除しました"
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
                                  :password_confirmation)
    end
end
