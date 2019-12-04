class PatchOldTrades < ActiveRecord::Migration[5.2]
  def up
    execute "UPDATE trades SET buyer_id  = (SELECT user_id FROM orders WHERE orders.id = trades.buy_order_id)"
    execute "UPDATE trades SET seller_id = (SELECT user_id FROM orders WHERE orders.id = trades.sell_order_id)"
  end

  def down
  end
end
