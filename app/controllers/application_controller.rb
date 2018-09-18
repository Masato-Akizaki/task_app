class ApplicationController < ActionController::Base
  include SessionsHelper

private

  def require_login
    unless logged_in?
      flash[:danger] = "ログインして下さい"
      redirect_to login_url
    end
  end

  #現在のユーザーのタスクか検証
  def correct_have_task
    @task = Task.find_by(id: params[:id])
    redirect_to(root_url) unless current_have_task?(@task)
  end
end
