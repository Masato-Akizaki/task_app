class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :logged_in_user, except: :index
  before_action :correct_user, except: :index

  def index
    if logged_in?
      @user = current_user
      @tasks = @user.tasks.search(params[:name],params[:status]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(20)
    end
  end

  def new
    @task = Task.new
  end

  def create
    @user = current_user #ログイン機能作成後、ログインユーザーのid参照に変更 
    @task = @user.tasks.build(task_params)
    if @task.save
      flash[:success] = "タスクを登録しました"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @task = Task.find_by(id: params[:id])
  end

  def edit
    @task = Task.find_by(id: params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = "タスクを更新しました"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    @task.destroy
    flash[:success] = "タスクを削除しました"
    redirect_to root_url
  end

  private

    def task_params
      params.require(:task).permit(:name, :detail, :deadline, :status, :priority)
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
    end
  
    def sort_column
        Task.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end
    
end
