# frozen_string_literal: true

require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    @email = (0...10).map do
      ('a'..'z').to_a[rand(26)]
      end.join + '@gmail.com'
    @password = 'A' + (0...10).map do
      ('a'..'z').to_a[rand(26)]
      end.join
    @name = (0...20).map do
      ('a'..'z').to_a[rand(26)]
      end.join
    @body = 'B' + (0...20).map do
      ('a'..'z').to_a[rand(26)]
      end.join
    @question = questions(:one)
    @question_two = questions(:two)
    @answer = answers(:one)
    @answer_two = answers(:two)
  end

  # тест предствления
  test "should get edit user" do
    user = User.new email: @email, name: @name, password: @password, password_confirmation: @password, body: @body
    assert user.save
    post '/session', params: { email: user.email, password: @password } 
    assert_response :redirect
    get edit_user_url(user)
    assert_response :success
    assert_select 'input[name="user[email]"]'
    assert_select 'input[name="user[name]"]'
    assert_select 'input[name="user[password]"]'
    assert_select 'input[name="user[password_confirmation]"]'
    assert_select 'textarea[name="user[body]"]'
  end

    # тест представления
  test "should get show user" do
    user = User.new email: @email, name: @name, password: @password, password_confirmation: @password, body: @body
    assert user.save
    post '/session', params: { email: user.email, password: @password } 
    assert_response :redirect
    get user_url(user)
    assert_response :success
  end 

  # тест представления
  test "shoud new topic form" do
    user = User.new email: @email, name: @name, password: @password, password_confirmation: @password, body: @body
    assert user.save
    post '/session', params: { email: user.email, password: @password } 
    assert_response :redirect
    get new_question_path
    assert_response :success
    assert_select 'input[name="question[title]"]'
    assert_select 'textarea[name="question[body]"]'
    assert user.destroy
  end

    # тест представления
  test "shoud edit topic form" do
    user = User.new email: @email, name: @name, password: @password, password_confirmation: @password, body: @body
    assert user.save
    post '/session', params: { email: user.email, password: @password } 
    assert_response :redirect
    question = user.questions.build title: @question.title, body: @question.body
    assert question.save
    get edit_question_path(question)
    assert_response :success
    assert_select 'input[name="question[title]"]'
    assert_select 'textarea[name="question[body]"]'
    assert user.destroy
  end

    # тест представления
  test "shoud new answer form" do
    user = User.new email: @email, name: @name, password: @password, password_confirmation: @password, body: @body
    assert user.save
    post '/session', params: { email: user.email, password: @password } 
    assert_response :redirect
    question = user.questions.build title: @question.title, body: @question.body
    assert question.save
    get question_path(question)
    assert_response :success
    assert_select 'textarea[name="answer[body]"]'
    assert user.destroy
  end

    # тест представления
  test "shoud edit answer form" do
    user = User.new email: @email, name: @name, password: @password, password_confirmation: @password, body: @body
    assert user.save
    post '/session', params: { email: user.email, password: @password } 
    assert_response :redirect
    question = user.questions.build title: @question.title, body: @question.body
    assert question.save
    answer = user.answers.build body: @answer.body, question_id: question.id
    assert answer.save
    get edit_question_answer_path(question, answer)
    assert_response :success
    assert_select 'textarea[name="answer[body]"]'
    assert user.destroy
  end

    # тест на изменение кол-ва юзеров
  test 'should difference count user' do
    assert_difference('User.count') do
      post users_url, params: { user: {email: @email, name: @name, password: @password, password_confirmation: @password, body: @body }}
    end
  end

    # тест действий юзера
  test 'user with correct credentials will see the root' do
    user = User.new email: @email, name: @name, password: @password, password_confirmation: @password, body: @body
    assert user.save
    post '/session', params: { email: user.email, password: @password } 
    assert_response :redirect
    question = user.questions.build title: @question.title, body: @question.body
    assert question.save
    answer = user.answers.build body: @answer.body, question_id: question.id
    assert answer.save
    assert answer.update body: @answer_two.body
    assert answer.destroy
    assert question.update title: @question_two.title, body: @question_two.body
    assert question.destroy
    session.delete :user_id
  end
end
