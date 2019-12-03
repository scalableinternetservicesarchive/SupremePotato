class TradesForeignKeys < ActiveRecord::Migration[5.2]
  def change
  	#add_foreign_key :trades, :orders, column: :buy_order_id, primary_key: "id"
    #add_foreign_key :trades, :orders, column: :sell_order_id, primary_key: "id"
  end
end
