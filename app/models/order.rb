class Order < ApplicationRecord
  # Performance: counter_cache updates tenants.orders_count automatically
  belongs_to :tenant, counter_cache: true
  # Specify class_name as User because the column name is coach_id / client_id
  belongs_to :coach, class_name: "User"
  belongs_to :client, class_name: "User"

  enum :status, { pending: 0, paid: 1, cancelled: 2 }, default: :pending

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true

  # Audit Integrity: Prevent editing core data after payment is confirmed
  validate :prevent_changes_after_paid, on: :update

  private

  def prevent_changes_after_paid
    if status_was == "paid" && (amount_changed? || description_changed?)
      errors.add(:base, "Paid orders are frozen and cannot be modified.")
    end
  end
end
