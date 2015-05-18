require 'test_helper'

class WeatherControllerTest < ActionController::TestCase
  test "should get data" do
    get :data
    assert_response :success
  end

end
