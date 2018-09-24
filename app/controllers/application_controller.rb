class ApplicationController < ActionController::Base
  include SessionsHelper

  # 例外処理
#rescue_from Exception, with: :render_500
#rescue_from ActiveRecord::RecordNotFound, with: :render_404
#rescue_from ActionController::RoutingError, with: :render_404
#rescue_from NoMethodError, with: :render_404

def render_403
  render template: 'errors/error_403', status: 403, layout: 'application', content_type: 'text/html'
end

def render_404
  render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
end

def render_500
  render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
end

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
    render_403 unless current_have_task?(@task)
  end
end
