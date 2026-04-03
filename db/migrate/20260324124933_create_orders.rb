class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      # Multi-tenancy isolation at the database level
      t.references :tenant, null: false, foreign_key: true

      # Role-based associations pointing to the users table
      t.references :coach, null: false, foreign_key: { to_table: :users }
      t.references :client, null: false, foreign_key: { to_table: :users }

      # Financial precision: 10 digits total, 2 after the decimal point
      # Manually adding precision and scale here
      t.decimal :amount, precision: 10, scale: 2, default: 0.0, null: false

      # State machine: 0: pending, 1: paid, 2: cancelled
      t.integer :status, default: 0, null: false
      t.text :description

      t.timestamps
    end

    # Performance Optimization: Composite Index
    # Optimizes the common query: "Find pending orders for a specific client within this tenant"
    add_index :orders, [ :tenant_id, :client_id, :status ], name: 'idx_orders_on_tenant_client_status'
  end
end
