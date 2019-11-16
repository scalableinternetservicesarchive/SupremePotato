class Company < ApplicationRecord
    has_many :orders
    has_many :trades
    has_many :holdings

    def price
        if @price.nil?
            trade  = self.trades.order('updated_at DESC').last

            if trade
                @price = trade.price
            else
                # Get CEO's sale price
                @price = self.orders.where(order_type: Order::SELL).order('updated_at DESC').first.price
            end
        end

        @price
    end
end
