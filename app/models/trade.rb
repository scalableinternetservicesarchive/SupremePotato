class Trade < ApplicationRecord
  belongs_to :buy_order,  class_name: 'Order'
  belongs_to :sell_order, class_name: 'Order'
  belongs_to :company

  def self.match!(buy, sell, price)
    Holding.where(
      user_id:    buy.user_id,
      company_id: buy.company_id
    ).first_or_create.increment!(:quantity, 1)

    Holding.where(
      user_id:    sell.user_id,
      company_id: sell.company_id,
    ).first_or_create.decrement!(:quantity, 1)

    buy.user.decrement!(:balance, price)
    sell.user.increment!(:balance, price)

    self.create!(
      buy_order:  buy,
      sell_order: sell,
      price:      price,
      company_id: buy.company_id
    )

    buy.update_attributes!(:status => Order::COMPLETED)
    sell.update_attributes!(:status => Order::COMPLETED)
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
