class Trade < ApplicationRecord
  belongs_to :buyer,      class_name: 'User'
  belongs_to :seller,     class_name: 'User'
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

    ).first_or_create.decrement!(:quantity, quantity)

    buy.user.decrement!(:balance, paid)
    sell.user.increment!(:balance, paid)

    self.create!(
      buyer_id:   buy.user_id,
      seller_id:  sell.user_id,
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

  def buyer_name
    Rails.cache.fetch("user_name_#{self.buyer_id}") {self.buyer.name}
  end

  def seller_name
    Rails.cache.fetch("user_name_#{self.seller_id}") {self.seller.name}
  end
end
