class LabelsController < ApplicationController
  before_action :require_login

  def index
    @labels = Label.all.page(params[:page]).per(20)
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:success] = "ラベル作成をしました！"
      redirect_to labels_path
    else
      render "new"
    end
  end

  def show
    @labels = Label.all
    @label = Label.find_by(id: params[:id])
  end

  def edit
    @label = Label.find_by(id: params[:id])
  end

  def update
    @label = Label.find_by(id: params[:id])
    if @label.update_attributes(label_params)
      flash[:success] = "ラベルを更新しました"
      redirect_to labels_path
    else
      render 'edit'
    end
  end

  def destroy
    @label = Label.find_by(id: params[:id])
    if @label.nil?
      redirect_to labels_path
    elsif @label.destroy
      flash[:success] = "ラベルを削除しました"
      redirect_to labels_path
    else
      redirect_to labels_path
    end
  end

  private

    def label_params
      params.require(:label).permit(:name)
    end
  
end
