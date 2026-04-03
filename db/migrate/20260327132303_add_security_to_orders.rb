class AddSecurityToOrders < ActiveRecord::Migration[8.0]
  def change
    # 1. Add idempotency key to prevent duplicate orders from a single request
    add_column :orders, :idempotency_key, :string
    add_index :orders, :idempotency_key, unique: true

    # 2. Ensure description is not null at the database level
    change_column_null :orders, :description, false

    # 3. Ensure amount is always positive (PostgreSQL-specific check constraint)
    # execute "ALTER TABLE orders ADD CONSTRAINT amount_check CHECK (amount > 0);"
  end
end
