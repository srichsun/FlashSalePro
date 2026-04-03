# spec/requests/tenant_isolation_spec.rb
require 'rails_helper'

RSpec.describe "Tenant Data Isolation", type: :request do
  let(:tenant_a) { Tenant.create!(name: "Coach A", invitation_token: "token_a", subdomain: "a") }
  let(:tenant_b) { Tenant.create!(name: "Coach B", invitation_token: "token_b", subdomain: "b") }

  let(:coach_a) { User.create!(email: "a@test.com", password: "password", role: :coach, tenant: tenant_a) }
  let(:order_b) { Order.create!(tenant: tenant_b, amount: 100, description: "Secret B", coach: coach_b, client: client_b) }
  # ... (略過 order_b 的關聯物件建立)

  it "does not show other tenant's orders to coach A" do
    post login_path, params: { email: coach_a.email, password: 'password' }

    get orders_path
    # 確保頁面不含其他租戶的資訊
    expect(response.body).not_to include("Secret B")
  end
end
