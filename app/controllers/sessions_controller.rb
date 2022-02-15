# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :no_authentication, only: %i[new create]
  # страница авторизации
  def new; end

# метод создания сессии
  def create
    user = User.find_by email: params[:email]
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "#{t("flash.success_logged_in")} #{user.name}!"
      redirect_to root_path
    else
      flash[:warning] = t("flash.incorrectly_data")
      redirect_to new_session_path
    end
  end
  
# метод удаления сессии
  def destroy
    sign_out
    flash[:success] = t("flash.success_logged_out")
    redirect_to root_path
  end
end
