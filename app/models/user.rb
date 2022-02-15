# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password # хэширование пароля
  has_many :questions, dependent: :destroy # юзер может иметь много вакансий
  has_many :answers, dependent: :destroy # юзер может иметь много отзывов 
  validates :email, presence: true, uniqueness: true, length: { minimum: 6 } # проверка на уникальность почты
  validates :name, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 5 }
end
