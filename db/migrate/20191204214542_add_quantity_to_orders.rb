class AddQuantityToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :quantity, :integer, default: 1, null: false
  end
end
