# coding: utf-8
class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
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
      params.require(:task).permit(:name, :detail)
    end

end
