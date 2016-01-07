require 'test_helper'

class ErrorLogsControllerControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get fix" do
    get :fix
    assert_response :success
  end

end
