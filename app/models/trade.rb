class Trade < ApplicationRecord
    belongs_to :buy_order,  class_name: 'Order'
    belongs_to :sell_order, class_name: 'Order'
    belongs_to :company

    def cached_buy_order
        Rails.cache.fetch('order_id' + self.buy_order_id.to_s) do
            Rails.logger.info '<<<CACHE NOT FOUND + DB CALL>>>' + 'order_id' + self.buy_order_id.to_s
            self.buy_order
        end
    end

    def cached_sell_order
        Rails.cache.fetch('order_id' + self.sell_order_id.to_s) do
            Rails.logger.info '<<<CACHE NOT FOUND + DB CALL>>>' + 'order_id' + self.sell_order_id.to_s
            self.sell_order
        end
    end
end
