require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  # тест представления
  test "should get index" do
    get root_url
    assert_response :success
  end
end
