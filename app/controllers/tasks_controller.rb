class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(
      name: params[:name],
      detail: params[:detail]
    )
    if @task.save
      redirect_to("/")
    else
      render("tasks/new")
    end
  end

  def show
    @task = Task.find_by(id: params[:id])
  end

  def edit
    @task = Task.find_by(id: params[:id])
  end

  def update
    @task = Task.find_by(id: params[:id])
    @task.name = params[:name]
    @task.detail = params[:detail]
    if @task.save
      redirect_to("/")
    else
      render("tasks/edit")
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    @task.destroy
    redirect_to("/")
  end
end
