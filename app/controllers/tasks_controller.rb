class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :require_login, except: :index
  before_action :correct_have_task, only: [:show]

  def index
    if logged_in?
      @tasks = current_user.tasks.search(params[:name], params[:status], params[:labels]).order("#{sort_column}" => sort_direction).page(params[:page]).per(20)
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
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
      redirect_to task_url(id: params[:id])
    else
      render "edit"
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to root_url
    elsif @task.destroy
      flash[:success] = "タスクを削除しました"
      redirect_to root_url
    else
      redirect_to root_url
    end
  end

  private

    def task_params
      params.require(:task).permit(:name, :detail, :deadline, :status, :priority, {  label_ids: [] })
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
    end
  
    def sort_column
        Task.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end
    
end
