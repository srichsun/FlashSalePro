require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "coach sees coach dashboard" do
    login_as(users(:coach_one))
    get dashboard_path
    assert_response :success
    assert_includes response.body, "Coach Overview"
    assert_select "h2", "Your Clients"
  end

  test "client sees client dashboard" do
    login_as(users(:client_one))
    get dashboard_path
    assert_response :success
    assert_includes response.body, "Orders & Billing"
    assert_select "h3", "Orders & Billing"
  end
end
