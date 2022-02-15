# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question   # отзыв может иметь много отзывов
  belongs_to :user       # отзыв может иметь много юзеров
  validates :body, presence: true, length: { minimum: 4 }
end
