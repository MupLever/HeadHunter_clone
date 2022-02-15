# frozen_string_literal: true

class AnswersController < ApplicationController
# методы, которые выполняются до загрузки  
  before_action :authentication, only: %i[create update edit destroy]
  before_action :recieve_question
  before_action :recieve_answers, except: :create
  before_action :authorization_user, only: %i[update edit destroy]

# создание отзыва
  def create
    @answer = @question.answers.build answers_create_params
    if @answer.save
      redirect_to question_path(@question)
      flash[:success] = t("flash.create_answer")
    else
      render 'question/show'
    end
  end

# удаление отзыва
  def destroy
    @answer.destroy
    flash[:success] = t("flash.delete_answer")
    redirect_to question_path(@question)
  end

# страница изменения отзыва
  def edit; end

# изменение отзыва
  def update
    if @answer.update answers_update_params
      redirect_to question_path(@question, anchor: "answer-#{@answer.id}")
      flash[:success] = t("flash.update_answer")
    else
      render :edit
    end
  end

  private

# ищем в бд вопрос по айди
  def recieve_question
    @question = Question.find params[:question_id]
  end

# ищем в бд все отзывы по айди 
  def recieve_answers
    @answer = @question.answers.find params[:id]
  end

# из пост параметров забираем бади
  def answers_create_params
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end

# из пост параметров забираем бади
  def answers_update_params
    params.require(:answer).permit(:body)
  end

# Ограничение доступа к чужим ответам
  def authorization_user
    return if current_user == @answer.user

    flash[:warning] = t("flash.not_author")
    redirect_to root_path
  end
end
