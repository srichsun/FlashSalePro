class User < ApplicationRecord
  has_secure_password
  belongs_to :tenant

  validates :name, presence: true

  # Add this line: Establish the association between users and orders
  # If a coach, these are orders they "issued"; if a client, these are orders they "received"
  has_many :orders, foreign_key: :client_id

  # Note: You originally wrote student; it's recommended to change to client for consistency or verify the mapping
  enum :role, { coach: 0, client: 1 }
end
