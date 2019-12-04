class Trade < ApplicationRecord
  belongs_to :buyer,      class_name: 'User'
  belongs_to :seller,     class_name: 'User'
  belongs_to :buy_order,  class_name: 'Order'
  belongs_to :sell_order, class_name: 'Order'
  belongs_to :company

  def self.match!(buy, sell, price)
    if buy.company_id != sell.company_id
      raise "Company mismatch!"
    end

    Holding.where(
      user_id:    buy.user_id,
      company_id: buy.company_id
    ).first_or_create.increment!(:quantity, 1)

    Holding.where(
      user_id:    sell.user_id,
      company_id: sell.company_id,
    ).first.decrement!(:quantity, 1)

    buy.user.increment!(:balance, buy.price - price)
    sell.user.increment!(:balance, price)

    self.create!(
      buyer_id:   buy.user_id,
      seller_id:  sell.user_id,
      buy_order:  buy,
      sell_order: sell,
      price:      price,
      company_id: buy.company_id
    )

    buy.update_attributes!(:status  => Order::COMPLETED)
    sell.update_attributes!(:status => Order::COMPLETED)
  end

  def buyer_name
    Rails.cache.fetch("user_name_#{self.buyer_id}") {self.buyer.name}
  end

  def seller_name
    Rails.cache.fetch("user_name_#{self.seller_id}") {self.seller.name}
  end
end
