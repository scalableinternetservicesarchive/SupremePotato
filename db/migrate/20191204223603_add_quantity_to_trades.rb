class AddQuantityToTrades < ActiveRecord::Migration[5.2]
  def change
    add_column :trades, :quantity, :integer, default: 1, null: false
  end
end
