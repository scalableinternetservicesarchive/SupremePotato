class Trade < ApplicationRecord
  belongs_to :buy_order,  class_name: 'Order'
  belongs_to :sell_order, class_name: 'Order'
  belongs_to :company

  def self.match!(buy, sell, price)
    quantity = [buy.quantity, sell.quantity].min
    paid     = quantity * price

    Holding.where(
      user_id:    buy.user_id,
      company_id: buy.company_id
    ).first_or_create.increment!(:quantity, quantity)

    Holding.where(
      user_id:    sell.user_id,
      company_id: sell.company_id,
    ).first.decrement!(:quantity, quantity)

    buy.user.increment!(:balance, (buy.price * quantity) - paid)
    sell.user.increment!(:balance, paid)

    self.create!(
      buy_order:  buy,
      sell_order: sell,
      quantity:   quantity,
      price:      price,
      company_id: buy.company_id
    )

    buy.quantity -= quantity
    buy.status = Order::COMPLETED if buy.quantity == 0
    buy.save!

    sell.quantity -= quantity
    sell.status = Order::COMPLETED if sell.quantity == 0
    sell.save!
  end

  def cached_buy_order
    Rails.cache.fetch('order_id' + self.buy_order_id.to_s) do
      Rails.logger.debug '<<<CACHE NOT FOUND + DB CALL>>>' + 'order_id' + self.buy_order_id.to_s
      self.buy_order
    end
  end

  def cached_sell_order
    Rails.cache.fetch('order_id' + self.sell_order_id.to_s) do
      Rails.logger.debug '<<<CACHE NOT FOUND + DB CALL>>>' + 'order_id' + self.sell_order_id.to_s
      self.sell_order
    end
  end
end
