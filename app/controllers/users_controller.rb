class UsersController < ApplicationController
  before_action :require_login, only: [:index, :show, :edit, :update, :destroy]
  #before_action :correct_user, only: [:index, :show, :edit, :update, :destroy]

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

  def index
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    end
end
