require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end
    # тест на несохранение невалидного юзера в бд
  test "should new user empty by setup" do
    user = User.new
    assert !user.save
  end
  # тест на сохранение валидного юзера в бд
  test "should new and destroy user no empty by setup" do
    assert @user.save
    if @user.save
      assert @user.destroy
    end
  end
end
