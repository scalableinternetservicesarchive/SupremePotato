class Order < ApplicationRecord
  belongs_to :user
  belongs_to :company

  PENDING   = 0
  COMPLETED = 1
  CANCELED  = 2

  BUY  = 1
  SELL = 2

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


  def cached_user_name
    Rails.cache.fetch('user_name_' + self.user_id.to_s) do
      Rails.logger.debug '<<<CACHE NOT FOUND + DB CALL>>>' + 'user_id' + self.user_id.to_s
      User.find(self.user_id).name
    end
  end
end
