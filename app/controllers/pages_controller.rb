# frozen_string_literal: true

class PagesController < ApplicationController

  # паджинация вакансий пользователя
  def index
    @questions = current_user.present? ? current_user.questions.order(created_at: :desc).page(params[:page]) : nil
  end
end
