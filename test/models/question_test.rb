require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  setup do
    @question = questions(:one)
    @question_second = questions(:two)
    @user = users(:one)
    @question_second.user = @user
    @question.user = @user
  end
    # тест на несохранение невалидной вакансии в бд
  test "should new question empty by setup" do
    question = Question.new
    assert !question.save
  end
  # тест на сохранение валидной вакансии в бд
  test "should new question no empty by setup" do
    assert @question.save
    if @question.save
      assert @question.destroy
    end
  end
end
