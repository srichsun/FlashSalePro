require "test_helper"

class TenantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tenants_index_url
    assert_response :success
  end

  test "should get show" do
    get tenants_show_url
    assert_response :success
  end
end
