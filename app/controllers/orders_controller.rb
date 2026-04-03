class OrdersController < ApplicationController
  before_action :set_orders_scope


  def index
    # Performance: Eager load :client to prevent N+1 queries when displaying client names
    @orders = @orders_scope.includes(:client).order(created_at: :desc)

    # Business Metrics: Aggregating order data for the dashboard stats

    # 1. Monthly Revenue: Sum of all paid orders within the current month
    @monthly_revenue = @orders_scope.paid
                                    .where(created_at: Time.current.all_month)
                                    .sum(:amount)

    # 2. Pending Count: Total number of orders currently awaiting payment
    @pending_count = @orders_scope.pending.count

    # 3. Monthly Volume: Total order count for the current month for business tracking
    @monthly_total_orders = @orders_scope.where(created_at: Time.current.all_month).count
  end

  def new
    # Pre-set the client and generate a unique idempotency key for financial safety
    @order = @orders_scope.new(client_id: params[:client_id])
    @order.idempotency_key = SecureRandom.uuid

    @clients = current_tenant.users.where(role: :client)
  end

  def create
    # Always initialize through the scoped association for security
    @order = @orders_scope.new(order_params)
    @order.coach = current_user

    if @order.save
      # [Future Work]: Trigger ActiveJob for email notifications here
      redirect_to @order, notice: "Order created and sent successfully."
    else
      # Required for rendering the 'new' view again with error messages
      @clients = current_tenant.users.where(role: :client)
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    # 💡 Phase 2: Handle Double Submission (Idempotency)
    # If the same idempotency_key is sent twice, find the existing one and redirect
    existing_order = @orders_scope.find_by(idempotency_key: @order.idempotency_key)
    redirect_to existing_order, alert: "This order was already processed."
  end

  def show
    # 透過 scoped association 撈取，確保租戶隔離安全
    @order = @orders_scope.find(params[:id])
  end

  private

  def set_orders_scope
    # Essential for Multi-tenancy: users can never access data outside their tenant
    @orders_scope = current_tenant.orders
  end

  def order_params
    params.require(:order).permit(:amount, :description, :client_id, :idempotency_key)
  end
end
