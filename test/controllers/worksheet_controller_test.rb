require 'test_helper'

class WorksheetControllerTest < ActionController::TestCase
  test "should get get_worksheet" do
    get :get_worksheet
    assert_response :success
  end

end
