class Order < ApplicationRecord
  belongs_to :user
  belongs_to :company

  PENDING   = 0
  COMPLETED = 1
  CANCELED  = 2

  BUY  = 1
  SELL = 2

  validates_inclusion_of    :order_type, in: [BUY, SELL]
  validates_inclusion_of    :status,     in: [PENDING, COMPLETED, CANCELED]
  validates_numericality_of :quantity,   greater_than: 0, on: :create
  validates_numericality_of :price,      greater_than: 0

  def status_name
    case self.status
    when PENDING
      'PENDING'
    when COMPLETED
      'COMPLETED'
    when CANCELED
      'CANCELED'
    else
      'UNKNOWN STATUS'
    end
  end

  def order_name
    case self.order_type
    when BUY
      'BUY'
    when SELL
      'SELL'
    else
      'UNKNOWN ORDER TYPE'
    end
  end

  def matches
    match_type = (self.order_type == BUY)?  SELL        :  BUY
    match_cond = (self.order_type == BUY)? 'price <= ?' : 'price >= ?'
    match_sort = (self.order_type == BUY)? 'price ASC ' : 'price DESC'

    Order.where(
      company_id: self.company_id,
      order_type: match_type,
      status:     PENDING
    ).where(
      match_cond, self.price
    ).order(
      match_sort
    )
  end

  def user_name
    Rails.cache.fetch("user_name_#{self.user_id}") {self.user.name}
  end
end
