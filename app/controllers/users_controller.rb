# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :no_authentication, only: %i[new create]
  before_action :authentication, only: %i[edit update]
  before_action :set_user, only: %i[edit update show]
  before_action :authorization_user?, only: %i[edit update]
  # страница создания юзера
  def new
    @user = User.new
  end

# метод создания юзера
  def create
    @user = User.new recieve_params_for_new
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "#{t("flash.success_signed_in")} #{@user.name}!"
      redirect_to root_path
    else
      render :new
      flash[:warning] = "#{t("flash.not_success_signed_in")} #{@user.name}!"
    end
  end

# метод редактирования юзера
  def update
    if @user.update recieve_params_for_edit
      redirect_to root_path
      flash[:success] = t("flash.success_updated")
    else
      render :new
    end
  end

# страница редактирования юзера
  def edit; end

  # показываем раздел "о себе" текущего юзера
  def show; end
  
  private
# из пост параметров забираем те, которые нужны для регистрации
  def recieve_params_for_new
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :body)
  end

# из гет параметров забираем те, которые нужны для редактирования
  def recieve_params_for_edit
    params.require(:user).permit(:email, :nickname, :body)
  end

  # ищем юзера в бд
  def set_user
    @user = User.find params[:id]
  end

  # ограничение доступа на изменение других пользователей
  def authorization_user?
    return if current_user.email == @user.email

    flash[:warning] = t("flash.change_other_user")
    redirect_to root_path
  end
end
