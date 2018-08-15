class TasksController < ApplicationController
  def index
    @tasks = task.all
  end

  def new
    @task = Task.new
  end

  def create
  end

  def show
    @task = Task.find_by(id: params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
