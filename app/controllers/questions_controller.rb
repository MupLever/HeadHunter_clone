# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authentication, only: %i[new create update edit destroy]
  before_action :before_recieve, only: %i[show destroy edit update]
  before_action :authorization_user?, only: %i[update edit destroy]
  # паджинация всех вакансий
  def index
    @questions = Question.order(created_at: :desc).page params[:page]
  end
  
# страница создания вакансии
  def new
    @question = Question.new
  end

  # метод создания вакансии
  def create
    @question = current_user.questions.build recieve_params
    if @question.save
      flash[:success] = t("flash.create_topic")
      redirect_to root_path
    else
      render :new
    end
  end

  # метод редактирования вакансии
  def update
    if @question.update recieve_params
      redirect_to root_path
      flash[:success] = t("flash.update_topic")
    else
      render :new
    end
  end

# страница редактирования вакансии
  def edit; end

  # метод удаления вакансии
  def destroy
    @question.destroy
    flash[:success] = t("flash.delete_topic")
    redirect_to root_path
  end

# страница вакансии с отзывами
  def show
    @answer = @question.answers.build
    @answers = @question.answers.order(created_at: :desc).page params[:page]
  end

  private

  #из пост параметров забираем те, которые нужны для создания вакансии
  def recieve_params
    params.require(:question).permit(:title, :body)
  end

  # ищем вакансию в бд
  def before_recieve
    @question = Question.find params[:id]
  end

  # ограничение доступа на изменение чужой вакансии
  def authorization_user?
    return if current_user == @question.user

    flash[:warning] = t("flash.not_author")
    redirect_to root_path
  end
end
