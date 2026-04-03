module OrdersHelper
  def status_badge(status)
    case status
    when "pending"
      content_tag(:span, "Pending", class: "px-2 py-1 text-xs font-bold rounded-full bg-yellow-100 text-yellow-800")
    when "paid"
      content_tag(:span, "Paid", class: "px-2 py-1 text-xs font-bold rounded-full bg-green-100 text-green-800")
    when "cancelled"
      content_tag(:span, "Cancelled", class: "px-2 py-1 text-xs font-bold rounded-full bg-red-100 text-red-800")
    else
      content_tag(:span, status.titleize, class: "px-2 py-1 text-xs font-bold rounded-full bg-gray-100 text-gray-800")
    end
  end
end
