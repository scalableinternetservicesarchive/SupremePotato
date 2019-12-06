class AddMatchIndexToOrders < ActiveRecord::Migration[5.2]
  def change
    add_index :orders, [:status, :order_type, :company_id, :price]
  end
end
