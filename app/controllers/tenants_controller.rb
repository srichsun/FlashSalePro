class TenantsController < ApplicationController
  # Skip the tenant check only for the main landing page
  skip_before_action :set_current_tenant, only: [:index]

  def index
    # List all coaches for the "Hallway"
    @tenants = Tenant.all
  end

  def show
    # @current_tenant is already set by the before_action in ApplicationController
    # This page represents the specific coach's landing area
  end
end