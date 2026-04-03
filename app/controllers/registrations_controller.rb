# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  # Registration does not require login
  skip_before_action :set_current_tenant, only: [ :new, :create ]

  def new
    if params[:token].present?
      # Student path: Find an existing tenant via token
      @tenant = Tenant.find_by!(invitation_token: params[:token])
    else
      # Coach path: Create a new tenant object for the form
      @tenant = Tenant.new
    end
    @user = User.new
  end

  def create
    # Determine if it's a student joining via invitation link or a new coach
    if params[:invitation_token].present?
      create_client_from_invitation
    else
      create_new_coach_and_tenant
    end
  end

  private

  def tenant_params
    params.require(:tenant).permit(:name, :subdomain)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # Path A: Coach opening a studio (original logic with minor adjustments)
  def create_new_coach_and_tenant
    ActiveRecord::Base.transaction do
      # When creating a tenant, automatically generate a random invitation token and subdomain (as a fallback even if not currently used)
      @tenant = Tenant.create!(tenant_params.merge(
        invitation_token: SecureRandom.hex(10),
        subdomain: SecureRandom.alphanumeric(8).downcase
      ))
      @user = @tenant.users.create!(user_params.merge(role: :coach))
    end
    session[:user_id] = @user.id
    redirect_to dashboard_path, notice: "Welcome, Coach!"
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  # Path B: Student joining (simple addition logic)
  def create_client_from_invitation
    @tenant = Tenant.find_by!(invitation_token: params[:invitation_token])
    @user = @tenant.users.new(user_params.merge(role: :student))

    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Welcome to #{@tenant.name}!"
    else
      render :new, status: :unprocessable_entity
    end
  end
end
