require 'test_helper'

class SessionsTest < ActionDispatch::IntegrationTest
  test 'unauthorized user will be redirected to login page' do
    get root_url
    assert_response :success, controller: :sessions, action: :create
  end
    
    # тест на редирект на ту же страницу 
  test 'user with incorrect credentials will be redirected to login page' do
    post '/session', params: { email: Faker::Lorem.word, password: Faker::Lorem.word }
    assert_redirected_to new_session_path
  end
  
    # тест выхода из сис-ы
  test 'user can logout' do
    password = Faker::Lorem.word
    user = User.create(email: Faker::Lorem.word,name: Faker::Lorem.word, password: password, password_confirmation: password)
    post '/session', params: { email: user.email, password: password }
    delete session_path
    assert_redirected_to root_path
  end
end
