module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def current_have_task
    if session[:user_id]
      @current_have_task ||= Task.find_by(user_id: session[:user_id])
    end
  end

  def current_have_task?(task)
    if task.nil?
      redirect_to(root_url)
    else
      task.user_id == current_have_task.user_id
    end
  end
end
