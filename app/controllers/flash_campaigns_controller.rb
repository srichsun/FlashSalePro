class FlashCampaignsController < ApplicationController
  before_action :authenticate_user! # Ensure only logged-in coaches can access

  def index
    # Only show campaigns belonging to the current coach (tenant)
    @flash_campaigns = current_user.tenant.flash_campaigns.order(created_at: :desc)
  end

  def new
    @flash_campaign = current_user.tenant.flash_campaigns.new
  end

  def create
    @flash_campaign = current_user.tenant.flash_campaigns.new(campaign_params)

    # Sync remaining_stock with total_stock initially
    @flash_campaign.remaining_stock = @flash_campaign.total_stock

    if @flash_campaign.save
      redirect_to flash_campaigns_path, notice: "Flash sale created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def campaign_params
    params.require(:flash_campaign).permit(:title, :price, :total_stock, :expired_at, :product_image)
  end
end
