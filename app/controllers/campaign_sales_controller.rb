class CampaignSalesController < ApplicationController
  # No authentication required - fans should access this directly
  def show
    @campaign = FlashCampaign.find(params[:id])
    @order = @campaign.flash_orders.new
  end
end