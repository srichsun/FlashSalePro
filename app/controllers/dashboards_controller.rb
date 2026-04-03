class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.coach?
      # Coach context: Statistics and Client management
      @clients = current_tenant.users.where(role: :client)
      @recent_orders = current_tenant.orders.includes(:client).limit(10)
      render :coach_dashboard
    else
      # Client context: Personal order history
      @my_orders = current_user.orders.order(created_at: :desc)
      render :client_dashboard
    end
  end
end
