require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "coach sees coach dashboard" do
    login_as(users(:coach_one)) # Assuming a helper exists
    get dashboard_path
    assert_template :coach_dashboard
    assert_select "h2", "My Clients"
  end

  test "client sees client dashboard" do
    login_as(users(:client_one))
    get dashboard_path
    assert_template :client_dashboard
    assert_select "h2", "Orders & Billing"
  end
end
