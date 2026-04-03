class OrderMailer < ApplicationMailer
  # Send confirmation email to the fan
  def confirmation_email(order)
    @order = order
    @campaign = order.flash_campaign

    mail(
      to: @order.email,
      subject: "【#{@campaign.title}】搶購成功通知"
    )
  end
end
