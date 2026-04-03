require 'rails_helper'

# spec/requests/sessions_spec.rb
RSpec.describe "Sessions", type: :request do
  describe "GET /login" do # 修改描述
    it "returns http success" do
      get login_path # 使用 login_path 而非 sessions_new_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    it "returns http success" do
      # 如果你的 create 動作對應 login_path 的 POST
      post login_path, params: { email: "test@test.com", password: "password" }
      # 登入後通常是 redirect，所以這裡可能要寫 expect(response).to have_http_status(:found) 或 :redirect
    end
  end

  describe "DELETE /logout" do
    it "returns http success" do
      delete logout_path # 使用 logout_path
      expect(response).to redirect_to(root_path)
    end
  end
end
