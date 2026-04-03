require "test_helper"

class TenantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tenants_url
    assert_response :success
  end

  test "should get show" do
    login_as(users(:coach_one))
    get tenant_url(tenants(:one))
    assert_response :success
  end
end
