# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy # вакансия может иметь много отзывов, если вакансия удаляется, то удаляются отзывы
  belongs_to :user # вакансия может иметь много юзеров
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 4 }
end
