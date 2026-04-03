# spec/requests/dashboards_spec.rb
require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  # 建立測試資料
  let(:tenant) { Tenant.create!(name: "Gym", invitation_token: "test_token", subdomain: "gym") }
  let(:user)   { User.create!(email: "coach@test.com", password: "password", role: :coach, tenant: tenant) }

  it "returns http success when logged in" do
    # 1. 模擬登入 (這會建立 session)
    post login_path, params: { email: user.email, password: 'password' }

    # 2. 存取儀表板 (現在 ApplicationController 會從 session 抓到 tenant)
    get dashboard_path
    expect(response).to have_http_status(:success)
    expect(response.body).to include("Coach Overview")
  end

  it "redirects to login when not authenticated" do
    get dashboard_path
    expect(response).to redirect_to(login_path)
  end
end
